# Windows-Bootstrap

This is a simple Powershell script to automate the installation of programs and the setup Windows environment for a fresh install.

## Description

This script will, based on the flag provided, either install all programs in the included directory and change certain registry settings, or update already installed software. It utilizes ninite, chocolatey, and boxstarter. You can modify what's installed by providing your own gist with boxstarter.

## Getting Started

### Dependencies

* Windows 7 or greater
* Powershell 2.0 or greater

### Installing

* Download the latest [release]() or clone the repo
* Make sure all executable files are in the **appInstalls** folder
* Update **hostinfo.txt**

### Executing program

* Launch powershell.exe as admin
* Navigate to directory with script
```PowerShell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy bypass
.\installer.ps1
```
* All done

## Help

In powershell launch:
```PowerShell
.\installer.ps1 -?
```

## Authors

Dominique Pizzie  
[@DomPizzie](https://twitter.com/dompizzie)

## Version History

* 0.1
    * Initial Release

## License

This project is licensed under the MIT License - see the LICENSE.md file for details

## Acknowledgments

* [TechNet](https://technet.microsoft.com)
* [MSDN](https://msdn.microsoft.com)
