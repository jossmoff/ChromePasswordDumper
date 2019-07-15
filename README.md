# ChromePasswordDumper

**ChromePasswordDumper** is a portable tool to allow the recovery of passwords from Google Chrome for Windows using [PSSQlite](https://github.com/RamblingCookieMonster/PSSQLite).


# Setup

Copy the ChromePasswordDumper folder into the root directory of your memory stick like so: 
![enter image description here](https://lh3.googleusercontent.com/JUNOVPnvM8UDZwMEF7I0LpwaiQ-Ms5KiQt0-8rcXO9mQKVK8ax3m3WgOHiRZPvGcePM53ktb02wurbGK-8Q0e1PaT4AEiYbu--8Sf8fh7m7woMj5cE-D0j4K_1roZXiGzBkbBTVMz8tHco12wAia5Ng-cNjRwZwe7tn2g1nOzVZiJEu1y75y34q78-Milsttz3i-u99XNYv8Y65i8J98Dsm77S_7Wjh7m6shhyrToR0bZpw8KOotLb7E3cKkid0EEOkNBee5TRdobA7t9ToWtzU7UQqPOzskzvZPUBj5d6134IlOZAPP0z8pgeoBBhCtISu5NJGOCSjFo1I0HcS-eSUgP0ovVJ8GGdgquM0UPHgP0OrNkRVaBHd_6JfLqhl0FlxJ7wLIKLCKTHU75nOc3Jz5QDSCx646jiIBdKeyofiIyyFW3ea7ug3Oyz7oJSxruRqCY4vXVfU5mwi06zsIogmadMYh6ZvH2ZhMEKApIBWP2K14YOWD8rMewLR1x7ezpscQpRqIinqaKUXaLjL6l2RKyLhALoMmnJsRosjU40iXcCRhIi_XsBFdoEvFMa7ruiAHA6lpEwnXo3zY3XrPXyi5GvD9L8e0dHv_zk9QQpx7TeSV7HxToHkP_3C-njtxdvP5xkc0vVIbifLmNXcnOWeC9EyJbbk=w2982-h261-no)
> Make sure external library for the windows version [PSSQlite](https://github.com/RamblingCookieMonster/PSSQLite) is up to date.


# How it works
Google Stores the details for saved passwords in a SQLite Database called **Login Data** which holds encrypted password information. How these encrypted passwords are generated is dependant on the given OS.


Once the program has run it will place the exctracted data into a file called **(Current User)-pwd.txt** e.g **JossMoff-pwd.txt**. The ouput file has  this format:
```
+----------------+--+-----------+--+-----------+
| Website        |  | Username* |  | Password* |
+----------------+--+-----------+--+-----------+
| www.github.com |  | JossMoff  |  | 12345     |
+----------------+--+-----------+--+-----------+
| www.nectar.com |  |           |  |           |
+----------------+--+-----------+--+-----------+


* - May not have an entry
```

## Windows
In windows, **Login Data** is stored at:
` %LocalAppData%\Google\Chrome\User Data\Default\Login Data`

The password is encrypted using the Windows function [CryptProtectData](https://docs.microsoft.com/en-gb/windows/win32/api/dpapi/nf-dpapi-cryptprotectdata). Avoiding complexities, we need to use the counterpart to this function [CryptUnprotectData](https://docs.microsoft.com/en-gb/windows/win32/api/dpapi/nf-dpapi-cryptunprotectdata) in order to decode the passwords.

In order to do this, we call a Powershell instance from run.bat with the following code:
`powershell.exe -noprofile -executionpolicy bypass -file .\windows.ps1` 
allowing us to run our ps1 script by bypassing execution policies.
 


# Further Improvements
How I plan to extend the quick project:
 - Change the code so the main folder does not need to be in the root directory of the memory stick.
 - Provide OS X support
 - Provide Linux Support
