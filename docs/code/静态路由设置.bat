@echo off&setlocal enabledelayedexpansion 
cls
:: code by shuishui
color 0a
title ��������
mode con COLS=80 LINES=36
:menu
cls
ECHO.
ECHO                       + �����-��������-����� +
ECHO                     +�� �������� �������� ��������   +
ECHO                        +�����-shuishui-�����+
ECHO  -------------------------------------------------------------------------
echo   [1]. ���þ�̬·��    [2]. ȡ����̬·��    [3]. ����IP    [0 ]. �˳� 
ECHO  -------------------------------------------------------------------------
ECHO.
ECHO  ��ʾ��Vista���Ժ�Ĳ���ϵͳ���Ҽ�ѡ���ù���Ա�������!
ECHO. 

:menu2
SET cho2=
SET /p cho2= ѡ�����:
echo.

if /i "%cho2%"=="0" (
echo.^>^>^>^>^>^>^>^>^>^>^>^>^>[RETURN]^<^<^<^<^<^<^<^<^<^<^<
goto end
)

SET orderIP=ipv4
netsh interface ipv4 show config>nul 2>nul || SET orderIP=ip

if /i "%cho2%"=="3" (
echo.^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>[ %cho2%]^<^<^<^<^<^<^<^<^<^<^<^<^<^<
@REM ������"Ethernet adapter"
set orderID=%cho2%
set uip= &set /a numb=0&set /a uipnum=0
for /f "usebackq delims=: tokens=1" %%a in (`"ipconfig | find "Ethernet adapter""`) do (
call set uip=%%uip%%"%%a" 
call set /a uipnum=%%uipnum%%+1
call echo %%uipnum%%. %%a
)
call set uip=%%uip:Ethernet adapter =%%
call :cchoice70
call :cchoice71 %%uip%%
echo.������[%cho2%]��
echo.
)
if /i "%cho2%"=="1" (
echo.^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>[ %cho2%]^<^<^<^<^<^<^<^<^<^<^<^<^<^<
set orderID=%cho2%
set uip= &set uip1=&set /a uipnum=0&set /a numb=0
@REM ����"Ethernet adapter""Default Gateway"��������
for /f "usebackq tokens=1 delims=:" %%a in (`"ipconfig | find "Ethernet adapter""`) do (
call set uip=%%uip%%"%%a" 
)
call set uip=%%uip:Ethernet adapter =%%
call :cchoice70 "00" 01
call :cchoice70
call :cchoice71 %%uip%%
echo.������[%cho2%]��
echo.
)
if /i "%cho2%"=="2" (
echo.^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>[%cho2%]^<^<^<^<^<^<^<^<^<^<^<^<^<^<
rem ???????????????????????????????????????????????????
route delete 10.0.0.0
route delete 210.32.0.0
route delete 210.32.128.0
route delete 222.205.0.0
echo.������[%cho2%]��
echo.
)

echo.^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>[END]^<^<^<^<^<^<^<^<^<^<^<^<^<
goto menu2

:cchoice70
set uip1= 
if /i "%2"=="01" (
if /i "%orderID%"=="1" (
for %%a in (%uip%) do (
for /f "usebackq tokens=3" %%i in (`"netsh interface %orderIP% show config %%a | find "Default Gateway:""`) do (
call set uip1=%%uip1%%%%i 
call set /a uipnum=%%uipnum%%+1
call echo %%uipnum%%. %%a
echo.   "Default Gateway":%%i
))))
if /i "%2"=="01" (
if /i "%orderID%"=="1" (
if /i %uipnum% EQU 0 (
for %%a in (%uip%) do (
for /f "usebackq tokens=2" %%i in (`"netsh interface %orderIP% show config %%a | find "Ĭ������:""`) do (
call set uip1=%%uip1%%%%i 
call set /a uipnum=%%uipnum%%+1
call echo %%uipnum%%. %%a
echo.   "Ĭ������":%%i
)))
call set uip=%%uip1%%
goto end
))
if /i %uipnum% EQU 0 (
for /f "usebackq tokens=1 delims=:" %%a in (`"ipconfig | find "��̫��������""`) do (
call set uip=%%uip%%"%%a" 
if /i "%orderID%"=="3" (
call set /a uipnum=%%uipnum%%+1
call echo %%uipnum%%. %%a
)))
set uip=%uip:��̫�������� =%
if /i %uipnum% EQU 0 (
if /i "%orderID%"=="1" (
for %%a in (%uip%) do (
for /f "usebackq tokens=2" %%i in (`"netsh interface %orderIP% show config %%a | find "Ĭ������:""`) do (
call set uip1=%%uip1%%%%i 
call set /a uipnum=%%uipnum%%+1
call echo %%uipnum%%. %%a
echo.   "Ĭ������":%%i
))
call set uip=%%uip1%%
))
goto end

:cchoice71
if %uipnum% LSS 1 echo.û���ҵ�����ӿڣ�&goto end
if %uipnum% GTR 1 (
echo.&echo.   ����Ҫ���õĽӿڵ����,�˳�Q
set /p numb=   :
) else (set numb=1)
if /i "%numb%"=="Q" goto end
if %numb% LSS 1 (echo.����^<1��Ч��&goto cchoice71)
if %numb% LEQ 9 (
if %numb% LEQ %uipnum% (
call set uip=%%%numb%%
) else (echo.����^>=%uipnum%��Ч��&goto cchoice71)
) else (echo.����^>=9��Ч��&goto cchoice71)
if /i "%orderID%"=="1" (
route -4 -p add 10.0.0.0  mask 255.0.0.0 %uip% 2>nul || ^
route -p add 10.0.0.0  mask 255.0.0.0  %uip% >nul
route -4 -p add 210.32.0.0 mask 255.255.240.0 %uip% 2>nul  || ^
route -p add 210.32.0.0  mask 255.255.240.0  %uip% >nul
route -4 -p add 210.32.128.0 mask 255.255.192.0 %uip% 2>nul || ^
route -p add 210.32.128.0  mask 255.255.192.0  %uip% >nul
route -4 -p add 222.205.0.0 mask 255.255.128.0 %uip% 2>nul  || ^
route -p add 222.205.0.0  mask 255.255.128.0  %uip% >nul
goto end)

set myip=
set mygateway=
set mydns=10.10.0.21
echo.&echo.   ����Ҫ����IP
set /p myip=   :
echo.   ����Ҫ��������
set /p mygateway=   :
echo.   ����Ҫ����DNS
set /p mydns=   :

if /i "%orderID%"=="3" (
sc start dhcp >nul 2>nul
netsh interface ip set address name=%uip% source=static addr^
=%myip% mask=255.255.255.0 gateway=%mygateway% gwmetric=0 || ^
netsh interface ipv4 set address name=%uip% source=static addr^
=%myip% mask=255.255.255.0 gateway=%mygateway% gwmetric=0

netsh interface ip set dns name=%uip% source=static addr=%mydns% register=PRIMARY || ^
netsh interface ipv4 set dns name=%uip% source=static addr=%mydns% register=PRIMARY
sc stop dhcp >nul 2>nul
)
goto end

:end 
