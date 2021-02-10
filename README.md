# Clip_B64
This project intended to copy content of file into clipboard.
In linux/cygwin there are simple commands to do so:
```bash
base64 < file | clip
```
But in GUI no souch simple way.

Just put `Release\Clip_B64.exe` into `%AppData%\Microsoft\Windows\SendTo` folder and use "Send To" context menu to put file on.
Result will be copied into the clipboard in base64 encoding, and can be inserted into the remote putty ssh remote shell window and decoded with `base64 -d`.
