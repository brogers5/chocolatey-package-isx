
---

### [choco://isx](choco://isx)

To use choco:// protocol URLs, install [(unofficial) choco:// Protocol support](https://community.chocolatey.org/packages/choco-protocol-support)

---

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
