﻿

Stop-Transcript -ErrorAction SilentlyContinue
$d = Get-Date -Format MM.dd.yyyy-HH.mm

Start-Transcript \\vault\tech3\Scripts\Matt\logs\FilerUsage$d.txt

CLS


Write-Host FilerCheck.ps1 -- compares current directory sizes against snapshots
Write-Host ""
Write-Host "Transcript Started - Script Will Log output to \\vault\tech3\Scripts\Matt\logs\FilerUsage$d.log"
Write-Host ""

$AZUSERS = gci \\vault\userdata$\~snapshot\daily.0\azusers | `
 where { $_.name -notlike 'profile*' -and $_.Name -notlike 'systems' -and $_.Name -notlike 'crossdep' -and $_.Name -notlike 'EntBPI' -and $_.Name -notlike 'shared'}

ForEach($Folder in $AZUSERS | Where {$_.PSisContainer -eq $True} | Sort-Object){

$UNC = ($Folder.PSPath).Split("::")[2]

ForEach($DIR in Get-ChildItem -Filter * $UNC | Where {$_.PSisContainer -eq $True} | Sort-Object)
{
$CurrentDir = ($DIR.PSPath).Split("::")[2]

$LastWeek = $CurrentDir.Replace("~snapshot\daily.0", "~snapshot\daily.6")

Write-Host -------------------------------------------------------------------------------------
Write-Host "Current Week $CurrentDir --- "(Get-Date)
Write-Host "Last Week    $LastWeek --- " (Get-Date)
Write-Host ""

$Bytes= Get-ChildItem -Filter * $CurrentDir -Recurse -ErrorAction "SilentlyContinue" | Where {$_.Length -ne $null} | Measure-Object -Property Length -Sum
$GB = [MATH]::Round(($Bytes.SUM / 1GB), 2)
Write-Host "Directory $DIR Currently contains "$($GB)GB" of Data"

$OldBytes = Get-ChildItem -Filter * $LastWeek -Recurse -ErrorAction "SilentlyContinue" | Where {$_.Length -ne $null} | Measure-Object -Property Length -Sum
$OldGB = [MATH]::Round(($OldBytes.SUM / 1GB), 2)

$Diff = [MATH]::Round(($GB - $OldGB), 2)

#Write-host $DIR



Write-Host "Last Week $DIR Contained ........."$($OldGB)GB" of Data"
Write-Host "Difference of ........................"$($Diff)GB""
Write-Host ""

IF($Diff -ge 1)
{Write-Output -forecolor red "Directory $DIR has grown by "$($Diff)GB"" >> \\vault\Tech3\Scripts\Matt\logs\ExcessiveGrowth$d.log}

}
}
Stop-Transcript