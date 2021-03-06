

FOREACH($COMPUTER in $SERVERS)
{$COMPUTER = $COMPUTER.name
    Write-Output (Get-date) $COMPUTER >> \\vault\tech3\Scripts\Matt\logs\ExtraCrawler_Server_Progress.txt
    Write-Host (Get-date) $COMPUTER
    $Test = Test-Connection -Count 1 -ComputerName $COMPUTER -ErrorAction SilentlyContinue
        IF($Test -ne $null)
            {
            Write-Host Ping Succeeded... Beginning Query...
            $QUERY = Get-ChildItem -Recurse \\$COMPUTER\c$ -Filter extra.exe | Where-Object { $_.pspath -notlike '*Exchange Server*'} | Where-Object { $_.pspath -notlike '*serverroles\common*'}
            Write-Host ________________________________________________________
                IF($QUERY -ne $null)
                {Write-Host "Attachmate Executable Detected on" 
                $QUERY
                $SUBJECT= "Attachmate Executable Detected on $COMPUTER"
                $BODY = $QUERY.PSPath
                Send-MailMessage -To $TO -From $FROM -Subject $SUBJECT -Body $BODY -SmtpServer $SMTP -BodyAsHtml
                }
            }
        ELSE
            {Write-Host Ping Failed...
			Write-Host ________________________________________________________}
}
Stop-Transcript -ErrorAction SilentlyContinue

Send-MailMessage -To $TO -From $FROM -Subject "Extra_Crawler.ps1 -completed!!!" -Body "Please Review Logs" -SmtpServer $SMTP -Priority High