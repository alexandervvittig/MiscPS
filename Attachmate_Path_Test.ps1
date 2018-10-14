$d = Get-Date -Format MM.dd.yyyy-HH.mm

Stop-Transcript
Start-Transcript \\vault\tech3\Scripts\Matt\logs\Attachmate_Path_Test$d.txt
 Import-Module ActiveDirectory
 $SERVERS = Get-ADComputer -SearchBase "OU=AZ,OU=Servers,DC=SHAMROCKFOODS,DC=COM" -Filter * | sort name | select name

 $Count = 0
 FOREACH($COMPUTER in $SERVERS)
 {$COMPUTER = $COMPUTER.name
 #Write-Host $COMPUTER
 $Test = Test-Connection -Count 1 -ComputerName $COMPUTER -ErrorAction SilentlyContinue
        IF($Test -ne $null)
            { 
            $TEST1 = $null
            $TEST2 = $null
            $Count++
            Write-Host $Count $COMPUTER
            $TEST1 = Test-Path "\\$COMPUTER\C$\Program Files\Attachmate"
           
            IF($TEST1 -eq "True")
            {Write-Host Attacmate Directory found at "\\$COMPUTER\C$\Program Files\Attachmate"
            Invoke-Item "\\$COMPUTER\C$\Program Files\Attachmate"
            Write-Host --------------------------------------------
            Write-Host Script Paused... Press Any Key to continue.
            Write-Host --------------------------------------------
            cmd /c pause | Out-Null
            }
            ELSE
            { 
            #do nothing
            }

            $TEST2 = Test-Path "\\$COMPUTER\C$\Program Files (x86)\Attachmate"
           
            IF($TEST2 -eq "True")
            {Write-Host Attacmate Directory found at "\\$COMPUTER\C$\Program Files (x86)\Attachmate"
            Invoke-Item "\\$COMPUTER\C$\Program Files (x86)\Attachmate"
            Write-Host --------------------------------------------
            Write-Host Script Paused... Press Any Key to continue.
            Write-Host --------------------------------------------
            cmd /c pause | Out-Null
            }
            ELSE
            {
            #do nothing
            }
            
            }
            ELSE
            {Write-Host Ping Failed...
			Write-Host ________________________________________________________}
 }
 Stop-Transcript