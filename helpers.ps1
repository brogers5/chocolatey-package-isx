Import-Module PowerShellForGitHub

$archiveFileNameRegex = 'ISx-v([\d\.]+)\.7z$'
$owner = 'lifenjoiner'
$repository = 'ISx'

function Get-LatestStableVersion {
    $latestRelease = (Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Latest)[0]

    return [Version] $latestRelease.tag_name.Substring(1)
}

function Get-SoftwareUri([Version] $Version) {
    if ($null -eq $Version) {
        # Default to latest stable version
        $release = (Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Latest)[0]
    }
    else {
        $release = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Tag "v$($Version.ToString())"
    }
    $releaseAssets = Get-GitHubReleaseAsset -OwnerName $owner -RepositoryName $repository -Release $release.ID

    $windowsPortableArchiveAsset = $null
    foreach ($asset in $releaseAssets) {
        if ($asset.name -match $archiveFileNameRegex) {
            $windowsPortableArchiveAsset = $asset
            break
        }
        else {
            continue
        }
    }

    if ($null -eq $windowsPortableArchiveAsset) {
        throw 'Cannot find published Windows portable archive asset!'
    }

    return $windowsPortableArchiveAsset.browser_download_url
}
