<#

    .SYNOPSIS
    This is a simple Powershell script to automate the installation of programs and the Windows environment for a fresh install.
    
    .DESCRIPTION
    This script will, based on the flag provided, either install all programs in the included directory and change certain registry settings, or update already installed software. It utilizes ninite, chocolatey, and boxstarter. You can modify what's installed by providing your own gist with boxstarter.

    .EXAMPLE
    freshInstall.ps1

    .EXAMPLE
    freshInstall.ps1 -update

    .NOTES
    Copyright (c) 2017, Dominique Pizzie
    Copyrights licensed under the MIT License (MIT).
    See the accompanying LICENSE file for terms.


    .LINK
    https://ninite.com/
    https://chocolatey.org/
    http://boxstarter.org/

#>

param (
    [switch]$update
)

if (!$update) {
    $boxstarter = 'http://boxstarter.org/package/nr/url?'
    $installDirectory = '.\appInstalls'
    ### Edit these URLs to your own install file
    $chocoList = 'https://gist.githubusercontent.com/DomPizzie/f16556b326d0bd19ede16bc586a9a124/raw/a47c518ff11092a320cffd8a18c9de12307958f1/VMSetup.txt'
    $niniteList = 'https://ninite.com/chrome-firefox-keepass2-notepadplusplus-peazip-putty-vscode-winscp/ninite.exe'
    $boxstarter = $boxstarter + $chocoList
    
    ### Use Boxstarter web installer to intialize Windows settings and install Chocolatey
    Write-Host 'Installing from boxstarter'
    Start-Process -FilePath 'iexplore.exe' -ArgumentList $boxstarter
    Start-Sleep -Seconds 15
    Read-Host -Prompt 'Press Enter to continue'

    ### Install from ninite.exe
    ### If ninite is not downloaded, go download and execute
    Write-Host 'Installing from ninite'
    $niniteExe = Get-ChildItem -Path $HOME\Downloads\ -Filter 'Ninite' | Sort-Object LastAccessTime -Descending | Select-Object -First 1
    $niniteExe.FullName
    if (!$niniteExe) {
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($niniteList,"$HOME\Downloads\Ninite.exe")
        Start-Process -FilePath "$HOME\Downloads\Ninite.exe" -Wait
    } else {
        Start-Process -FilePath $niniteExe.FullName -Wait
    }
    
    ### Install all applications inside of included directory
    Write-Host 'Installing from appInstalls'
    [string[]]$installArray = @(Get-ChildItem -Path $installDirectory -Name)
    $count = 0
    if ($installArray) {
        foreach($installer in $installArray) {
            $count++
            Write-Progress -Activity 'Installing...' -Status $installer -PercentComplete ($count / $installArray.Length * 100) -CurrentOperation "$count of $($installArray.Length) complete"
            Start-Process -FilePath $installer -WorkingDirectory $installDirectory -Wait
        }
        Write-Progress -Activity 'Installing...' -Status 'Complete' -Completed 
    }

    ### Update hostfile with items in hostinfo.txt
    Write-Host 'Updating host file'
    $hostPath = "$env:windir\System32\drivers\etc\hosts"
    $hostinfo = Get-Content .\hostinfo.txt
    Add-Content -Path $hostPath -Value $hostinfo

}
else {
    ### Update flag was set
    ### Run ninite and choco updates
    $niniteExe = Get-ChildItem -Path $HOME\Downloads\ -Filter 'Ninite' | Sort-Object LastAccessTime -Descending | Select-Object -First 1
    if ($niniteExe) { 
        Start-Process -FilePath $niniteExe.FullName
    }
    choco upgrade all
}
