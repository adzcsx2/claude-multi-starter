
$Host.UI.RawUI.WindowTitle = "Sending to c2"
# Focus the target tab and send text
wt.exe -w 0 focus-tab --target 12
Start-Sleep -Milliseconds 500

# Send the text character by character (workaround for WT limitation)
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("测试")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
