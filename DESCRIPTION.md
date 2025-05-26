## ISx

ISx is a simple file extractor that extracts all components of a given InstallShield installer executable, including (but not limited to):

- InstallShield CAB files
- Compiled installation scripts/rules (i.e. INX/INS files)
- Setup initialization files
- Language-specific string resource files
- Underlying MSI packages
- Packaged setup prerequisites

ISx is intended to serve as an open-source alternative to `IsXunpack`.

### Usage Example

```shell
ISx.exe "D:\Local\setup.exe"
```

## Package Parameters

The packaged archive ships with both x86 (32-bit) and amd64 (64-bit) binaries, but this package will only create a single shim (named `ISx`) appropriate for your environment by default. If you require different shimming behavior, use the appropriate switch(es) for your use case:

|Parameter|Environment Applicability|Description|
|-|-|-|
|`/ShimWithPlatform`|All environments|Creates a second shim with an explicit platform name (i.e. `ISx-x86` and/or `ISX-amd64`). Use if you require disambiguation for your commands/scripts.|
|`/SkipLegacyShim`|32-bit only (forceable in 64-bit with `--forcex86` switch)|For backward compatibility with legacy use cases depending on the x86 binary, the `ISx` shim will target the x86 binary instead. Use if this shim is undesired or unnecessary. Usage implies `/ShimWithPlatform`, as no shim would otherwise be created if omitted.|
|`/ShimAllBinaries`|64-bit only|Use if you require both binaries to be shimmed. For naming consistency with the x86 binary, consider combining with `/ShimWithPlatform`.|
