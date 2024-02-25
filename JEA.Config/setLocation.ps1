# Changes the default location on connection to C:\temp as the original default is C:\Windows\System32, which is dangerous
$path = 'C:\temp'
Set-Location -Path $path