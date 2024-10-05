@echo off
:menu
cls
echo ==========================================
echo      Welcome to the System Info Tool!
echo ==========================================
echo.
echo 1. Display System Information
echo 2. Display Hardware Information
echo 3. Display Network Information
echo 4. Display Disk Usage
echo 5. Display Battery Information
echo 6. Log Info to File
echo 7. Real-time CPU/Memory Usage
echo 8. Exit
echo.
set /p choice="Select an option (1-8): "

if %choice%==1 goto sysInfo
if %choice%==2 goto hardwareInfo
if %choice%==3 goto networkInfo
if %choice%==4 goto diskInfo
if %choice%==5 goto batteryInfo
if %choice%==6 goto logInfo
if %choice%==7 goto cpuMemoryUsage
if %choice%==8 exit
goto menu

:sysInfo
echo Gathering system information...
echo ==========================================
systeminfo | findstr /C:"OS Name"
systeminfo | findstr /C:"System Model"
systeminfo | findstr /C:"Total Physical Memory"
systeminfo | findstr /C:"Available Physical Memory"
systeminfo | findstr /C:"System Boot Time"
echo ==========================================
pause
goto menu

:hardwareInfo
echo Gathering hardware information...
echo ==========================================
echo CPU Information:
wmic cpu get Name, NumberOfCores, NumberOfLogicalProcessors
echo ------------------------------------------
echo Disk Drives:
wmic diskdrive get Model, Size
echo ------------------------------------------
echo Memory (RAM):
wmic memorychip get Capacity, Manufacturer, Speed
echo ------------------------------------------
echo Graphics Card:
wmic path win32_VideoController get Name
echo ==========================================
pause
goto menu


:networkInfo
echo Gathering network information...
echo ==========================================
echo IP Address:
ipconfig | findstr /C:"IPv4 Address"
echo ------------------------------------------
echo MAC Address:
getmac
echo ------------------------------------------
echo Network Adapter Details:
wmic nic get Name, MACAddress
echo ==========================================
pause
goto menu

:diskInfo
echo Checking disk usage...
echo ==========================================
wmic logicaldisk get DeviceID, FreeSpace, Size, FileSystem
echo ==========================================
pause
goto menu

:batteryInfo
echo Checking battery status...
echo ==========================================
wmic path Win32_Battery get EstimatedChargeRemaining, BatteryStatus
echo ==========================================
pause
goto menu

:logInfo
echo Saving system and hardware info to log.txt...
(
    echo System Information:
    systeminfo | findstr /C:"OS Name" /C:"System Model"
    echo ------------------------------------------
    echo Hardware Information:
    wmic cpu get Name, NumberOfCores
    wmic diskdrive get Model, Size
    wmic memorychip get Capacity, Speed
    wmic path win32_VideoController get Name
    echo ------------------------------------------
    echo Network Information:
    ipconfig | findstr /C:"IPv4 Address"
    getmac
) >> log.txt
echo Information saved to log.txt!
pause
goto menu

:cpuMemoryUsage
echo Press CTRL+C to stop the monitoring...
:loop
echo ==========================================
echo Current CPU and Memory Usage:
wmic cpu get LoadPercentage
wmic OS get FreePhysicalMemory, TotalVisibleMemorySize
timeout /t 3
goto loop
