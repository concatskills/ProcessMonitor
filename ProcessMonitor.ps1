<#
.SYNOPSIS
    Process Monitor
.DESCRIPTION
    Record trace to monitor process
.NOTES
    File Name      : ProcessMonitor.ps1
    Author         : Sarah BESSARD (sarah.bessard@concatskills.com)
    Prerequisite   : PowerShell V5 over Vista and upper.
    Copyright 2018 - Sarah BESSARD / CONCAT SKILLS
.LINK
    Script posted over:
    http://www.concatskills.com/2018/02/09/trace-process-monitor
    https://github.com/concatskills/ProcessMonitor
.EXAMPLE
    .\ProcessMonitor.ps1 -DurationInSec 30
#>

param(
    [Parameter(Mandatory=$False)] [int]$DurationInSec=30
    )

clear-host

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
$ScriptDirectoryExe = "$($ScriptDirectory)\exe"
$ScriptDirectoryOut = "$($ScriptDirectory)\out"

Push-Location $ScriptDirectory

$ProcMonExe = "$($ScriptDirectoryExe)\Procmon.exe"
$CapturePml = "$($ScriptDirectoryOut)\capture.pml"
$CaptureCsv = "$($ScriptDirectoryOut)\capture.csv"

$DurationInSec = [System.Math]::Abs($DurationInSec)

If(!(test-path $ScriptDirectoryOut)) { New-Item -ItemType Directory -Force -Path $ScriptDirectoryOut } else { Get-ChildItem -Path $ScriptDirectoryOut -Include *.* -Recurse  | remove-Item -Recurse -Force }
 
$argstart = "/Quiet /AcceptEula /Minimized /Backingfile $CapturePml /Runtime $DurationInSec"
$argstop = "/Openlog $CapturePml /SaveAs $CaptureCsv" 

# Warning UAC & run as admin
Start-Process -FilePath $ProcMonExe -ArgumentList $argstart -wait -Verb RunAs
Start-Process -FilePath $ProcMonExe -ArgumentList $argstop -wait -Verb RunAs
