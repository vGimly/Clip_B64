# Clip_B64
This project intended to copy content of file into clipboard.

In linux/cygwin there are simple commands to do so:
```bash
base64 < file | clip
```
But there is no such easy way in the GUI.

Just place `Release\Clip_B64.exe` in the `%AppData%\Microsoft\Windows\SendTo` folder and use the "Send To" context menu to place the file on the clipboard.
The result is base64 encoded and can be pasted from the clipboard into the putty-ssh remote shell window and decoded using the console command `base64 -d`.
