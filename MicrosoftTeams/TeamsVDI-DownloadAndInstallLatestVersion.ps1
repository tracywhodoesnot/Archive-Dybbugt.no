﻿####------------------------------------------------------------------------####
#### Downloads and install Microsoft Teams x64 for VDI
#### Can be run later to update packages
#### 
#### Creator info: Geir Dybbugt - https://dybbugt.no
####------------------------------------------------------------------------####

#Variables
$Masterdestination = "$env:APPDATA\DybbugtNO-Files"
$TeamsDestination = "$Masterdestination\Teams"

#Folder Structure

    #Creating root folder
    MD $Masterdestination -force

    #Creating Subfolders
    MD $TeamsDestination -force
	
#Set TLS protocol type
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


 #Downloading source file
    $TeamsDownload = ((Invoke-WebRequest -Uri 'https://docs.microsoft.com/en-us/microsoftteams/teams-for-vdi' -UseBasicParsing ).Links | where outerHTML -Like "*64-bit version*").href
    Start-BitsTransfer -Source $TeamsDownload -Destination "$TeamsDestination"

 #start installation
    cd $TeamsDestination
    start-process msiexec.exe -argumentlist "/i `"$TeamsDestination\teams_windows_x64.msi`"  ALLUSER=1 ALLUSERS=1" -wait
    cd \
    #Remove registry keys to stop Teams from autostarting
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "Teams"

    #Remove shortcut public desktop
    remove-item -Path "C:\Users\Public\Desktop\Microsoft Teams.lnk" -Force
 
  #Cleaning up downloaded files
    start-sleep -Seconds 10
    remove-item $TeamsDestination -recurse -Force
    remove-item $Masterdestination -recurse -Force