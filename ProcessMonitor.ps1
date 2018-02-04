param(
    [Parameter(Mandatory=$True)] [int]$DurationInSec
    )

clear-host

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
$ScriptDirectoryExe = "$($ScriptDirectory)\exe"
$ScriptDirectoryOut = "$($ScriptDirectory)\out"

Push-Location $ScriptDirectory

$ProcMonExe = "$($ScriptDirectoryExe)\Procmon.exe"
$CapturePml = "$($ScriptDirectoryOut)\capture.pml"
$CaptureCsv = "$($ScriptDirectoryOut)\capture.csv"

If(!(test-path $ScriptDirectoryOut)) { New-Item -ItemType Directory -Force -Path $ScriptDirectoryOut } else { Get-ChildItem -Path $ScriptDirectoryOut -Include *.* -Recurse  | remove-Item -Recurse -Force }
 
# Warning UAC & run than admin
Start-Process -FilePath $ProcMonExe -ArgumentList “/Quiet /AcceptEula /Minimized /Backingfile $CapturePml /Runtime $DurationInSec” -wait -Verb RunAs
Start-Process -FilePath $ProcMonExe -ArgumentList "/Openlog $CapturePml /SaveAs $CaptureCsv" -wait -Verb RunAs