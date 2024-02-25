"Welcome, you have securely connected to {0}" -f ("$env:USERDOMAIN\$env:COMPUTERNAME") | Write-Host -ForegroundColor Green
"Current sessions:" | Write-Host
(Get-WSManInstance -ResourceURI Shell -Enumerate).Owner | Write-Host -ForegroundColor Green