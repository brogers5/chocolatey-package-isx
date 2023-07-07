Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$legalPath = Join-Path -Path $currentPath -ChildPath 'legal'
$softwareRepo = 'lifenjoiner/ISx'

function global:au_BeforeUpdate($Package) {
    Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256

    Copy-Item -Path "$legalPath\VERIFICATION.txt.template" -Destination "$legalPath\VERIFICATION.txt" -Force

    Set-DescriptionFromReadme -Package $Package -ReadmePath '.\DESCRIPTION.md'
}

function global:au_AfterUpdate($Package) {
    $licenseUri = "https://raw.githubusercontent.com/$softwareRepo/v$($Latest.SoftwareVersion)/LICENSE"
    $licenseContents = Invoke-WebRequest -Uri $licenseUri -UseBasicParsing

    Set-Content -Path 'legal\LICENSE.txt' -Value "From: $licenseUri`r`n`r`n$licenseContents" -NoNewline
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(<packageSourceUrl>)[^<]*(</packageSourceUrl>)" = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            "(<licenseUrl>)[^<]*(</licenseUrl>)"             = "`$1https://github.com/$softwareRepo/blob/v$($Latest.SoftwareVersion)/LICENSE`$2"
            "(<projectSourceUrl>)[^<]*(</projectSourceUrl>)" = "`$1https://github.com/$softwareRepo/tree/v$($Latest.SoftwareVersion)`$2"
            "(<docsUrl>)[^<]*(</docsUrl>)"                   = "`$1https://github.com/$softwareRepo/blob/v$($Latest.SoftwareVersion)/readme.txt`$2"
        }
        'legal\VERIFICATION.txt'        = @{
            '%checksumValue%'  = "$($Latest.Checksum32)"
            '%checksumType%'   = "$($Latest.ChecksumType32.ToUpper())"
            '%tagReleaseUrl%'  = "https://github.com/$($owner)/$($repository)/releases/tag/v$($Latest.SoftwareVersion)"
            '%binaryUrl%'      = "$($Latest.Url32)"
            '%binaryFileName%' = "$($Latest.FileName32)"
        }
        'tools\chocolateyinstall.ps1'   = @{
            "(^[$]archiveFileName\s*=\s*)('.*')" = "`$1'$($Latest.FileName32)'"
        }
    }
}

function global:au_GetLatest {
    $version = Get-LatestStableVersion

    return @{
        Url32           = Get-SoftwareUri
        Version         = $version #This may change if building a package fix version
        SoftwareVersion = $version
    }
}

Update-Package -ChecksumFor None -NoReadme
