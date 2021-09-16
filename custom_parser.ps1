$parsed = ("parsed_" + $args[0])

(Get-Content $args[0] | Select -Index 4).Substring(9) | Out-File "tmp_working.log"
Add-Content "tmp_working.log" -Value (Get-Content $args[0] | Select-Object -Skip 5)
Import-Csv -Delimiter " " -Path "tmp_working.log" | Select-Object date,time,time-taken,c-ip,cs-userdn,cs-auth-group,x-exception-id,sc-filter-result,cs-categories,cs`(Referer`),sc-status,s-action,cs-method,rs`(Content-Type`),cs-uri-scheme,cs-host,cs-uri-port,cs-uri-path,cs-uri-query,cs-uri-extension,cs`(User-Agent`),s-ip,sc-bytes,cs-bytes,x-virus-id | Export-Csv -Delimiter " " -Path 'tmp_working2.log' -NoTypeInformation -UseQuotes AsNeeded

(Get-Content "tmp_working2.log" | Select -Index 0).Insert(0, "#Fields: ") | Out-File $parsed
Add-Content $parsed -Value (Get-Content "tmp_working2.log" | Select-Object -Skip 1)

Remove-Item -Path "tmp_working.log"
Remove-Item -Path "tmp_working2.log"