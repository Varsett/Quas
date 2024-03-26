# Quas - QUest ADB Scripts
## Description of work and functional capabilities

### Description of work:
The Quas program is designed, in particular, to help solve problems with Meta Quest headsets, as well as to simplify the use of many standard commands and actions, both documented and not very. In fact, this is a multitool, a Swiss knife for enthusiasts and owners of Quest headsets.

The program is written in cmd with some inserts of scripts from other languages: JS, VSH, VBS, etc.

Packed into an exe file using Quick Batch File Compiler. Contains additional freeware tools: wget, devcon, 7z, adb, aapt, etc.

The principle of working with the program is very simple: select a menu item and then follow either the prompts or the next item. Many options contain detailed instructions and explanations.
The program does not need to be installed, just run the quas.vX.X.X.exe file, wait a couple of seconds, and you can use it. You can also use some startup keys (see built-in help, item H). Each time Quas is started, it displays a table with the most important data on the Main screen.

### Functional capabilities:
* **Update management:** Allows you to turn off and on updates on the headset itself or the Oculus Home program.
 
* **Sending a text string to the headset:** Sending any text from the computer to the input field on the headset, for example, an address in a browser, a key to a VPN client, or a login/password in the corresponding fields.
 
* **Show hidden settings:** Display of hidden advanced settings on the headset.
 
* **Reboot into different modes and information about the current one:** Reboot into Sideload modes (two options), Fastboot, Bootloader, Recovery, and standard Reboot. Also allows you to determine which mode the headset is in at the moment.
 
* **Creating screenshots of the headset display:** Creating screenshots of the headset in three different variations: Single, Series of screenshots (each screenshot by pressing a key), and Automatic, with a certain interval. The interval between screenshots can be set manually.
 
* **Copying screenshots from the headset to the PC:** Copying all the screenshots available on the headset to the PC in a folder on the Desktop.

* **Connecting the headset "ADB over Wi-Fi":** In this mode, you can use ADB commands or the same Quas, without using a USB cable.

* **Reconnecting the headset "ADB over cable":** Switching to using ADB over cable, for example, for copying large files.

* **Connecting the headset as a removable disk:** In some cases, the PC does not connect the headset as a removable disk. The option allows you to forcibly resolve this issue.

* **Fixing the OpenSSL SHA Crash Bug error:** On Intel processors, starting with the 10th generation, there is a bug due to which many games on some versions of the Unreal Engine crash or do not start. This option fixes the bug.
* **Restarting the Oculus service on the PC:** Sometimes it is necessary to restart all services, and to avoid running around the Windows settings, you can use this option.

* **Solutions to various problems with the shell, dark screen, etc:**
    * **Restart the headset shell:** Solves the problem of the dark screen
    * **Restart the headset shell (second option):** Alternative option to the previous item
    * **Wi-Fi management on the headset:** Disables and enables Wi-Fi on the headset
    * **Force start of the headset home environment:** Allows you to exit the Home (Virtual) environment in case of a dark screen.
    * **Security System Management:** Disables and enables the security system (temporarily)
    * **Proximity sensor management:** Disables and enables the proximity sensor
    * **Fix the volume button restart problem (remove KeyMapper):** Removes the KeyMapper program, which cannot be removed in the usual way.
    * **Restart the ADB server on the PC:** Restarts the ADB server on the computer.
    * **Open VPN settings on the headset:** Opens VPN settings on the headset.

* **Testing, diagnostics, and system information:**
    * **Restore screen timeout settings (screen timeout):** Restores the default settings
    * **Work with dumpsys:** saving a full dump or list of services, searching by dump.
    * **Load monitoring and component diagnostics:** Monitoring the temperature of the CPU, GPU, case, battery. Display of fan speed, health and status, CPU/GPU working levels and CPU load
    * **Display all headset properties (getprop)**
    * **Show headset IP address:** Displays the current IP address of the headset
    * **Save a list of installed packages (packages names):** Saved in a brief and full format in text files.
    * **Show headset serial number:** Shows the headset serial number
    * **Headset system settings (setting list system/global/security):** Saves to file
    * **Work with Logcat:** Saving Logcat for a selected time or selected volume, can be set manually. Logcat search.
    * **Embed ADB and utility package into the system, as well as remove all this junk from it:** Copies several files to the system directory to work with adb without specifying the current directory
    * **Battery information:** Displays remaining, lost, learned, and nominal capacity. Shows battery degradation percentage, status, and health. Additional data is saved to file.
    * **Creating a shared resource on a PC:** Allows you to automate the process of creating a shared directory on a computer, for access from the headset to this network resource
    * **Extracting a bug report:** Extracts a bug report
    * **View CPU-intensive applications:** Displays a list of the most resource-intensive applications
    * **List of files/directories and their size:** Displays a list of available files and directories with their size.
    * **Show the amount of occupied space:** Shows the total memory volume, as well as how much is occupied, free, and the percentage of filling.
    * **USB device connection and disconnection log:** Saves Windows events to a file when a USB cable is disconnected and connected, with the date and time of the events specified.
    * **Cable health check:** USB cable test from PC to headset with test results output for each pass and data transfer rate for this cable.
    * **Camera health check (Quest 2 only):** Displays the temperature of the four external headset cameras. The temperature difference between them can determine the malfunction of any of them.
    * **Wi-Fi speed measurement between headset and PC:** The built-in Wireless Connect Tester utility is launched - Wi-Fi speed testing. Displays headset and PC IP addresses, allows you to specify your IP address 
for the PC if it is incorrect. You can specify the interval between checks (in milliseconds) and the duration of the check (in seconds). Two tests are conducted - direct and reverse. The results are saved in a 
text file.
    * **Network connection statistics (netstat):** Displays complete network connection statistics for the headset
    * **Display update information:** Displays information about which updates were installed after resetting the headset to factory settings and initial setup.
    * **Save all system information wholesale to one archive:** Saving complete information about the headset - system, global, security, bugreport, dumpsys, etc.

* **Firmware update and firmware information:**
    * **Fully automatic firmware:** The headset firmware update is fully automated, just place the firmware file next to the program with any name. Developer Mode is required.
    * **Button automatic firmware:** Semi-automatic firmware option. Everything is the same as in the previous item, but before flashing, you should boot the headset into Bootloader mode. Developer mode is not required.
    * **Extract the firmware link from the headset:** Extracts links (if there are several) to firmware from the headset, saves them to a text file, and downloads the firmware itself.
    * **Download various firmware versions:** Opens a browser with the address of the site where you can get the latest firmware versions
    * **Show current headset firmware version and check for updates:** Displays the current headset firmware version and if this version is not current, will display a message.
    * **Firmware Analyzer:** checks the firmware file for correctness and compatibility. Allows you to find out all the information about the firmware file: full or incremental, in the latter case, it will report the firmware version for which the increment is intended. It will show the environment version, firmware version, headset model, check the file for integrity, and also for compatibility with the current headset firmware version. As a result, it issues a summary of whether this file will be flashed. For a complete analysis, the computer must have access to the Internet. Otherwise, the information will be limited only to the firmware environment version.
    * **Additional explanations about incremental firmware**

* **List of additional commands and parameters (Help):** Restart as a user, restart as an administrator with a UAC request, restart as an administrator without a UAC request, accelerated Quas startup - without a table and checks, additional explanation about incremental firmware, enable installation with downgrade capability, enable display installation details, enable installation log file writing, headset partition table and their size in bytes and gigabytes.

* **Download/update progress, DNS setup:** View download progress with manual or automatic interval; checking with three search modules, sequential (by pressing a key) DNS server recording in the headset, automatic DNS selection for downloading updates (after each DNS check for access to servers for downloading), reset of the specified DNS server to default, installation of DNS internet blocker.

* **Application management:**
    * **Launch Quest Install Director application installation utility:** a comprehensive utility for installing applications both singly and in bulk - by files and directories
    * **Run applications on the headset:** launch some applications: VPN clients, etc.
    * **Find out the command to run an application on the headset:** allows you to find out the application name, its package name, and the command to run this application from a PC to the headset via adb.
    * **Show a list of installed applications:** displays a list of installed applications, by choice: system, unofficial, enabled, disabled, or all at once. It can also display only applications filtered by keyword
    * **VPN client and Oculus driver installation:** installs several VPN clients and Oculus drivers for Win7 and Win10
    * **Media application installation:** Installing media players, online cinemas, and torrent clients for online viewing.
    * **Application installation:** installs several applications: file managers, browsers, etc.

* **Setting of CPU/GPU levels:** setting seven levels of CPU/GPU performance and displaying the current levels.

* **Setting the native RefreshRate and display resolution:** allows you to set a higher resolution than the default display resolution to increase image clarity. It also allows you to change the refresh rate.

* **Oculus Link/Airlink management:** commands to enable and disable Link and AirLink, fix problem Airlink connection (delete *.pem files)

* **Creating shortcuts for file copying and application installation:** Launches the Quest Context Tool program, which allows you to install "Send" shortcuts for copying and installing applications to the context menu. After that, simply right-click on the file and install it or copy it to any of the headset directories - Movies, Download, OBB, or the root. It can install applications using the install.txt scenario, which is usually located in the game directory. And standard installation - apk and obb. Batch installation is also available - if you right-click on the games directory, all of them will be installed in turn. A detailed and understandable installation or copying log will be displayed during installation or copying. Contains built-in usage guide.

* **Set high priority to Oculus services:** Setting high priority to Oculus services.

* **Adjusting the date, time, and time zone on the headset:** the function checks the correctness of the set time, date, and time zone and, if necessary, will set the correct values.

* **Application data backup (Only Meta Quest 1/2):** saves all information from the Android/data directory and copies the archive to the PC

* **PC video streaming:** Works on the scrcpy program and contains five streaming modes from the headset to the PC - four preset and one manual. The manual mode can be configured independently using seven parameters - Bitrate, FPS, file recording, sound output, proximity sensor, and video codec. The subprogram can work with preinstalled profiles and contains six integrated profiles - minimum, light, balanced, demonstration, quality, maximum. Any of these profiles can be selected and the streaming can be started with it immediately. There is also the ability to configure your own profiles - up to four. They will be written to a separate file and can be loaded in the same way as integrated ones. In manual mode, there is also the ability to save the scrcpy launch line and edit it according to your preferences. Contains a built-in usage guide.

* **Open cmd console:** opens the Windows command line console in a separate window.

* **Open adb shell console:** opens the console for accessing the headset

* **Help with problem solving:** opens websites in the browser where you can get help or read instructions for solving various problems
