; @derezzedDev

#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
#Include TrayMinimizer.ahk
 
Menu, Tray, Icon, ico.ico, 1
Menu, Tray, Tip, Status Monitor
config_status := 0
 
; Initalize variables
IniRead, process, %appdata%\status-monitor-config.ini, config, process, %A_Space%
IniRead, interval, %appdata%\status-monitor-config.ini, config, interval, 60
IniRead, discord, %appdata%\status-monitor-config.ini, config, discord, 0
IniRead, sms, %appdata%\status-monitor-config.ini, config, sms, 0
IniRead, email, %appdata%\status-monitor-config.ini, config, email, 0
IniRead, notif, %appdata%\status-monitor-config.ini, config, notif, 3
IniRead, boot, %appdata%\status-monitor-config.ini, config, boot, 0
Transform, process, Deref, %process%
Transform, interval, Deref, %interval%
Transform, discord, Deref, %discord%
Transform, sms, Deref, %sms%
Transform, email, Deref, %email%
Transform, notif, Deref, %notif%
Transform, boot, Deref, %boot%
 
IniRead, webhook, %appdata%\status-monitor-config.ini, config, webhook, %A_Space%
IniRead, sms_from, %appdata%\status-monitor-config.ini, config, sms_from, %A_Space%
IniRead, sms_from_password, %appdata%\status-monitor-config.ini, config, sms_from_password, %A_Space%
IniRead, phonenum, %appdata%\status-monitor-config.ini, config, phonenum, %A_Space%
IniRead, provider, %appdata%\status-monitor-config.ini, config, provider, %A_Space%
IniRead, sms_smtp_server, %appdata%\status-monitor-config.ini, config, sms_smtp_server, %A_Space%
IniRead, sms_smtp_port, %appdata%\status-monitor-config.ini, config, sms_smtp_port, %A_Space%
IniRead, email_from, %appdata%\status-monitor-config.ini, config, email_from, %A_Space%
IniRead, email_from_password, %appdata%\status-monitor-config.ini, config, email_from_password, %A_Space%
IniRead, email_to, %appdata%\status-monitor-config.ini, config, email_to, %A_Space%
IniRead, email_smtp_server, %appdata%\status-monitor-config.ini, config, email_smtp_server, %A_Space%
IniRead, email_smtp_port, %appdata%\status-monitor-config.ini, config, email_smtp_port, %A_Space%
Transform, webhook, Deref, %webhook%
Transform, sms_from, Deref, %sms_from%
Transform, sms_from_password, Deref, %sms_from_password%
Transform, phonenum, Deref, %phonenum%
Transform, provider, Deref, %provider%
Transform, sms_smtp_server, Deref, %sms_smtp_server%
Transform, sms_smtp_port, Deref, %sms_smtp_port%
Transform, email_from, Deref, %email_from%
Transform, email_from_password, Deref, %email_from_password%
Transform, email_to, Deref, %email_to%
Transform, email_smtp_server, Deref, %email_smtp_server%
Transform, email_smtp_port, Deref, %email_smtp_port%

 ; Gui Layout
Gui, Font, s12, Courier New
Gui, Add, Text, x5 y5 hwndStatus, Status Monitor v2
Gui, Font, s10, Courier New
Gui, Add, Button, x560 y5 w35 h25 gcontrol_button hwndButton, OFF
Gui, Add, Text, x25 y35, Process:
Gui, Add, Text, x25 y60, Interval:
Gui, Add, Text, x160 y60, Notification Count:
Gui, Add, Text, x350 y60, At Bootup:
Gui, Add, Text, x25 y85, Config:
 
Gui, Font, s8, Courier New
Gui, Add, Edit, x100 y35 w400 h15 vprocess gsave, %process%
Gui, Add, Edit, x100 y60 w50 h15 vinterval gsave, %interval%
Gui, Add, Edit, x316 y60 w20 h15 vnotif gsave, %notif%
Gui, Add, Edit, x434 y60 w15 h15 vboot gsave, %boot%
Gui, Add, Button, x100 y85 gconfig_button, OPEN
Gui, Add, CheckBox, Checked%discord% vdiscord gsave, Discord
Gui, Add, CheckBox, Checked%sms% vsms gsave, SMS
Gui, Add, CheckBox, Checked%email% vemail gsave, Email
Gui, Add, Text, x555 y165 greadme, readme

if (boot == 1) {
   control_button_status := 1
   Guicontrol, Text, %Button%, ON
   FileCreateShortcut, %A_ScriptFullPath%, C:\Users\%A_UserName%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\StatusMonitor.lnk, %A_WorkingDir%
} else {
   control_button_status := 0
   FileDelete, C:\Users\%A_UserName%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\StatusMonitor.lnk
}
 
Gui, Show, w600 h180, `t
TrayMinimizer.Init(false)
Loop
{
   if (control_button_status = 1){
      Guicontrol, Text, %Status%, Status Monitor v2 - %countdown%
      Guicontrol, Move, %Status%, W275
      if (countdown <= 0){
         Process, Exist, %process% 
         {
            If ! errorLevel {
               If(notif != 0) {
                  if(discord = 1)
                  sendWebHook(webhook, process)
                  if(sms = 1)
                  sendSMTPText(sms_from, sms_from_password, phonenum, provider, sms_smtp_server, sms_smtp_port, process)
                  if(email = 1)
                  sendSMTPEmail(email_from, email_from_password, email_to, email_smtp_server, email_smtp_port, process)
               notif := notif - 1
            }}}
         countdown := interval
      }else 
         countdown := countdown - 1
   }
   Sleep, 1000
}
return
 
; Labels
control_button:
   if (control_button_status = 0){
      control_button_status := 1
      Guicontrol, Text, %Button%, ON
      Guicontrol, Move, %Status%, W275
      countdown := interval
      return
   }
   if (control_button_status = 1){
      control_button_status := 0
      Guicontrol, Text, %Button%, OFF
      Guicontrol, Text, %Status%, Status Monitor v2
      return
   }
return
 
config_button:
   if (config_status = 1){
      Gui, 3:Show,, config
   }else  {
      config_status := 1
      Gui, 3:Font, s10, Courier New
      Gui, 3:Add, Text, x5 y5, Discord:
      Gui, 3:Font, s8, Courier New
      Gui, 3:Add, Text, x25, Webhook:
      Gui, 3:Font, s10, Courier New
      Gui, 3:Add, Text, x5, SMS:
      Gui, 3:Font, s8, Courier New
      Gui, 3:Add, Text, x25, From:
      Gui, 3:Add, Text, x25, From Password:
      Gui, 3:Add, Text, x25, Phone Number:
      Gui, 3:Add, Text, x25, Provider Domain:
      Gui, 3:Add, Text, x25, SMTP Server:
      Gui, 3:Add, Text, x25, SMTP Port:
      Gui, 3:Font, s10, Courier New
      Gui, 3:Add, Text, x5, Email:
      Gui, 3:Font, s8, Courier New
      Gui, 3:Add, Text, x25, From:
      Gui, 3:Add, Text, x25, From Password:
      Gui, 3:Add, Text, x25, To:
      Gui, 3:Add, Text, x25, SMTP Server:
      Gui, 3:Add, Text, x25, SMTP Port:
      Gui, 3:Font, s8, Courier New
      Gui, 3:Add, Edit, x80 y27 w200 h15 vwebhook gsave, %webhook%
      Gui, 3:Add, Edit, x60 y70 w125 h15 vsms_from gsave, %sms_from%
      Gui, 3:Add, Edit, x118 y90 w125 h15 vsms_from_password gsave, %sms_from_password%
      Gui, 3:Add, Edit, x112 y110 w125 h15 vphonenum gsave, %phonenum%
      Gui, 3:Add, Edit, x130 y130 w145 h15 vprovider gsave, %provider%
      Gui, 3:Add, Edit, x105 y150 w145 h15 vsms_smtp_server gsave, %sms_smtp_server%
      Gui, 3:Add, Edit, x90 y170 w145 h15 vsms_smtp_port gsave, %sms_smtp_port%
      Gui, 3:Add, Edit, x60 y213 w145 h15 vemail_from gsave, %email_from%
      Gui, 3:Add, Edit, x120 y233 w145 h15 vemail_from_password gsave, %email_from_password%
      Gui, 3:Add, Edit, x47 y252 w145 h15 vemail_to gsave, %email_to%
      Gui, 3:Add, Edit, x105 y273 w145 h15 vemail_smtp_server gsave, %email_smtp_server%
      Gui, 3:Add, Edit, x92 y293 w145 h15 vemail_smtp_port gsave, %email_smtp_port%
      Gui, 3:Show,, config
   }
return
 
readme:
   Gui, 2:Font, s10, Courier New
   Gui, 2:Add, Text, x5 y5, Status Monitor is the easiest way to monitor running processes.
   Gui, 2:Add, Text, x5 y30, Usage:
   Gui, 2:Font, s8, Courier New
   Gui, 2:Add, Text, x20 y+0,Process:  Input the name of the process you'd like to monitor; for example 'scottbotv1.exe'
   Gui, 2:Add, Text, x20 y+0,Interval: Input the interval in whole seconds at which you'd like to monitor at; for example '60' for once per minute
   Gui, 2:Add, Text, x20 y+0,Notif:    Input the number of notifications you'd like to receive; such that you don't get notification bombed
   Gui, 2:Add, Text, x20 y+0,Bootup:   When selected Status Monitor will launch and start the monitoring process at bootup. Input 1 to enable.
   Gui, 2:Add, Text, x20 y+0,Config:   Input your personal details, such as your discord webhook for discord notifications
   Gui, 2:Add, Text, x20 y+0,`nOnce the configuration is to your liking hit the 'ON/OFF' button in the top right.`nA countdown will appear, when it reaches 0 a status evaluation will occur. 
   Gui, 2:Font, s10, Courier New
   Gui, 2:Add, Text, x5 y+0,`nContact:
   Gui, 2:Font, s8, Courier New
   Gui, 2:Add, Text, x20 y+0, @derezzedDev`nFeel free to shoot me a question or suggestion!
   Gui, 2:Show,, readme
return
 
save:
   Gui, Submit, NoHide
return
 
GuiClose:
   GuiControlGet, process
   StringReplace, process, process, `n, ``n, All
   IniWrite, %process%, %appdata%\status-monitor-config.ini, config, process
   GuiControlGet, interval
   StringReplace, interval, interval, `n, ``n, All
   IniWrite, %interval%, %appdata%\status-monitor-config.ini, config, interval
   GuiControlGet, discord
   StringReplace, discord, discord, `n, ``n, All
   IniWrite, %discord%, %appdata%\status-monitor-config.ini, config, discord
   GuiControlGet, sms
   StringReplace, sms, sms, `n, ``n, All
   IniWrite, %sms%, %appdata%\status-monitor-config.ini, config, sms
   GuiControlGet, email
   StringReplace, email, email, `n, ``n, All
   IniWrite, %email%, %appdata%\status-monitor-config.ini, config, email
   GuiControlGet, notif
   StringReplace, notif, notif, `n, ``n, All
   IniWrite, %notif%, %appdata%\status-monitor-config.ini, config, notif
   GuiControlGet, boot
   StringReplace, boot, boot, `n, ``n, All
   IniWrite, %boot%, %appdata%\status-monitor-config.ini, config, boot
   ExitApp
return
 
3GuiClose:
GuiControlGet, webhook
StringReplace, webhook, webhook, `n, ``n, All
IniWrite, %webhook%, %appdata%\status-monitor-config.ini, config, webhook
GuiControlGet, sms_from
StringReplace, sms_from, sms_from, `n, ``n, All
IniWrite, %sms_from%, %appdata%\status-monitor-config.ini, config, sms_from
GuiControlGet, sms_from_password
StringReplace, sms_from_password, sms_from_password, `n, ``n, All
IniWrite, %sms_from_password%, %appdata%\status-monitor-config.ini, config, sms_from_password
GuiControlGet, phonenum
StringReplace, phonenum, phonenum, `n, ``n, All
IniWrite, %phonenum%, %appdata%\status-monitor-config.ini, config, phonenum
GuiControlGet, provider
StringReplace, provider, provider, `n, ``n, All
IniWrite, %provider%, %appdata%\status-monitor-config.ini, config, provider
GuiControlGet, sms_smtp_server
StringReplace, sms_smtp_server, sms_smtp_server, `n, ``n, All
IniWrite, %sms_smtp_server%, %appdata%\status-monitor-config.ini, config, sms_smtp_server
GuiControlGet, sms_smtp_port
StringReplace, sms_smtp_port, sms_smtp_port, `n, ``n, All
IniWrite, %sms_smtp_port%, %appdata%\status-monitor-config.ini, config, sms_smtp_port
GuiControlGet, email_from
StringReplace, email_from, email_from, `n, ``n, All
IniWrite, %email_from%, %appdata%\status-monitor-config.ini, config, email_from
GuiControlGet, email_from_password
StringReplace, email_from_password, email_from_password, `n, ``n, All
IniWrite, %email_from_password%, %appdata%\status-monitor-config.ini, config, email_from_password
GuiControlGet, email_to
StringReplace, email_to, email_to, `n, ``n, All
IniWrite, %email_to%, %appdata%\status-monitor-config.ini, config, email_to
GuiControlGet, email_smtp_server
StringReplace, email_smtp_server, email_smtp_server, `n, ``n, All
IniWrite, %email_smtp_server%, %appdata%\status-monitor-config.ini, config, email_smtp_server
GuiControlGet, email_smtp_port
StringReplace, email_smtp_port, email_smtp_port, `n, ``n, All
IniWrite, %email_smtp_port%, %appdata%\status-monitor-config.ini, config, email_smtp_port
Gui, 3: Show, Hide
return
 
; Functions
sendWebHook(webhook, process) {
postdata=
(
{
  "username": "Status Monitor",
  "avatar_url": "https://i.imgur.com/5JlaCDa.png",
  "embeds": [
    {
      "title": "%process% is not currently running",
      "color": 15340307,
      "fields": [
        {
          "name": "Device Name:",
          "value": "%A_ComputerName%",
          "inline": true
        }
      ]
    }
  ]
}
)

WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WebRequest.Open("POST", webhook, false)
WebRequest.SetRequestHeader("Content-Type", "application/json")
WebRequest.Send(postdata)   
}

sendSMTPText(sms_from, sms_from_password, phonenum, provider, sms_smtp_server, sms_smtp_port, process) {
pmsg := ComObjCreate("CDO.Message")
pmsg.From := """ Status Monitor"" <" . sms_from . ">"
pmsg.To := "" . phonenum . provider . ""
pmsg.TextBody := process . " is not currently running"

fields := Object()
fields.smtpserver := "" . sms_smtp_server . ""
fields.smtpserverport := sms_smtp_port
fields.smtpusessl := True 
fields.sendusing := 2 
fields.smtpauthenticate := 1 
fields.sendusername := "" . sms_from . ""
fields.sendpassword := "" . sms_from_password . ""
fields.smtpconnectiontimeout := 60
schema := "http://schemas.microsoft.com/cdo/configuration/" 

pfld := pmsg.Configuration.Fields

For field,value in fields
pfld.Item(schema . field) := value
pfld.Update()

Loop, Parse, sAttach, |, %A_Space%%A_Tab%
pmsg.AddAttachment(A_LoopField)
pmsg.Send() 
}

sendSMTPEmail(email_from, email_from_password, email_to, email_smtp_server, email_smtp_port, process) {
pmsg := ComObjCreate("CDO.Message")
pmsg.From := """ Status Monitor"" <" . email_from . ">"
pmsg.To := "" . email_to . ""
pmsg.TextBody := process . " is not currently running"

fields := Object()
fields.smtpserver := "" . email_smtp_server . ""
fields.smtpserverport := email_smtp_port
fields.smtpusessl := True 
fields.sendusing := 2 
fields.smtpauthenticate := 1 
fields.sendusername := "" . email_from . ""
fields.sendpassword := "" . email_from_password . ""
fields.smtpconnectiontimeout := 60
schema := "http://schemas.microsoft.com/cdo/configuration/" 

pfld := pmsg.Configuration.Fields

For field,value in fields
pfld.Item(schema . field) := value
pfld.Update()

Loop, Parse, sAttach, |, %A_Space%%A_Tab%
pmsg.AddAttachment(A_LoopField)
pmsg.Send() 
}