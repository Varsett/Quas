## Quas - QUest ADB Scripts

#### Utility - a collection of the most commonly used commands and actions for the headset. It's like a "multitool" for beginners and      beyond. No need to search for and learn adb commands, parameters, and so on. %%<-
#### Just select the desired action from the list.

![](https://i.ibb.co/GPX1wqx/maineng.jpg)


![Download current release](https://github.com/Varsett/Quas/releases)

## **Description of Operation and Functional Capabilities of the Program**

### **Description of Operation:**
The **Quas** program is designed, in particular, to assist in solving issues with Meta Quest headsets, as well as to simplify the use of many standard commands and actions, both documented and undocumented. Essentially, it is a multi-tool, a Swiss army knife for enthusiasts and owners of Quest headsets.

The program is written in cmd with some script insertions from other languages: JS, VSH, VBS, etc. It is packaged into an exe file using Quick Batch File Compiler. It includes additional tools: devcon, 7z, adb, aapt, etc.

The principle of working with the program is very simple: you choose a menu item and then follow either the prompts or the next item. Many options include detailed instructions and explanations.

The program does not need to be installed; you simply run the `quas.v.X.X.X.exe` file, wait a couple of seconds, and you're ready to use it. You can also use some launch keys (see built-in help, **section H**). Each time **Quas** is launched, it displays a table with the most important data on the Main screen. The list of additional commands and parameters is at the end of this instruction.

The program features color (only for Win 10 and above) and letter markings indicating the mode or status of the headset. It is displayed in the upper left corner of the program, and it is convenient to use it with the **b** (**bypass**) key when the information table is hidden to speed up the program launch.

List of markings and their meanings:
  * NA - **Not Available** - Device not connected
  * DR - **No Driver**s - headset connected, but drivers not installed
  * CB - **Cable** - Device connected via cable
  * DB - **Doublc connection** - Double connection, via cable and Wi-Fi
  * WF - **Wi-Fi connection** - connected via Wi-Fi
  * DV - **No Developer** - Developer mode not enabled
  * AU - **No Authentication** - headset not authenticated
  * SL - **Sideload mode** - headset in Sideloader mode
  * BL - **Bootloader mode** - headset in Bootloader mode
  * NS - **Not Support** - Connected device is not a headset.
  * EM - **EDL Mode** - The headset is in Emergency Download Mode
  * OF - **Power Off** - The headset is turned off

### **Functional Capabilities:**

* **Update Management:** Allows turning updates on and off on the headset itself or Meta Quest Link programs.

* **Sending Text String to the Headset:** Sends any text from the PC to the input field on the headset, such as a browser address, VPN client key, or login/password into their respective fields.

* **Reboot into Various Modes and Current Mode Information:** Reboot modes include:
  * Resuming headset boot from Bootloader mode
  * Standard/reboot from the headset
  * Reboot headset to Bootloader mode
  * Reboot headset to Recovery mode
  * Reboot headset to Fastboot mode
  * Reboot headset to Sideload mode (regular variant)
  * Reboot headset to Sideload mode (alternative variant)
  * Identify current headset mode
  * Power off the headset

* **Taking Headset Display Screenshots:** Creates headset screenshots in three different variations:
  * Single
  * Series (one screenshot per key press)
  * Automatic, at specified intervals. Interval between screenshots can be set manually.

  Screenshots are copied to the Desktop in the Screenshots directory.

* **Copying Headset Screenshots to PC:** Copies all existing headset screenshots and videoshots to the Quest Media folder on the Desktop. If this folder doesn't exist, it will be created, with subdirectories for Screenshots and Videoshots.

* **Connecting the Headset via "ADB over Wi-Fi":** In this mode, ADB commands or the same Quas functions can be used without using a USB cable. This option works until reboot or as long as the `adb.exe` process is running on the PC.

* **Reconnecting the Headset via "ADB over Cable":** Switches to using ADB over a cable, for example, for copying large files.

* **Connecting the Headset as a Removable Disk:** In some cases, the PC does not connect the headset as a removable disk. This option allows you to forcibly resolve this issue.

* **System Information:**
  * **Working with dumpsys:** Saving a full dump or list of services, searching through the dump.
  * **Retrieve all headset properties (getprop)**
  * **Show the headset's IP address:** Displays the current IP address of the headset.
  * **Save a list of installed packages (package names):** Saved in both short and full formats to text files.
  * **Show the headset's serial number:** Displays the headset's serial number.
  * **Headset system settings (setting list system/global/security):** Saves to file.
  * **Working with Logcat:** Saving Logcat for a selected time or size range, manually adjustable. Logcat search.
  * **Battery information:** Displays remaining, lost, studied, and standard capacity. Shows battery degradation percentage, status, and health. Additional data saved to file.
  * **Extracting a bug report:** Extracts a bug report.
  * **View CPU-intensive applications:** Lists the most resource-intensive applications.
  * **List of files/directories and their sizes:** Lists available files and directories with their sizes.
  * **Show used storage space:** Displays total memory capacity, used, free, and percentage filled.
  * **USB device connection and disconnection log:** Saves Windows events for USB cable connection and disconnection with event date and time. Convenient for diagnosing headset disconnection issues from the PC.
  * **Save all system information in bulk to a single archive:** Saves complete headset information - system, global, security, bugreport, dumpsys, etc.

* **Testing, Diagnostics, and Troubleshooting Various Issues:**
  * **Restarting the headset shell:** Helps resolve a dark screen issue.
  * **Restarting the headset shell (alternate option):** Alternative option to the previous point.
  * **Wi-Fi management on the headset:** Enables and disables Wi-Fi on the headset.
  * **Forcing start of the headset's home environment:** Allows exiting to the Home (Virtual) environment in case of a dark screen. Equivalent to the Home button on Android devices.
  * **Security system management:** Temporarily disables and enables the security system.
  * **Proximity sensor management:** Disables and enables the proximity sensor.
  * **Fix volume button reboot issue (remove KeyMapper):** Removes the `KeyMapper` program, which cannot be removed conventionally.
  * **Restarting ADB server on PC:** Restarts the ADB server on the PC.
  * **Embedding ADB and utility package into the system, and removing all this junk from it:** Copies several files into the system directory for ADB operation without specifying the current directory.
  * **Executing Fastboot commands:** Includes commands such as:
    * **Fastboot devices:** Check device availability
    * **Fastboot oem device-info:** Collect and save device OEM information
    * **Fastboot getvar all:** Collect and save all possible device information
    * **Fastboot continue:** Continue headset boot
    * **Fastboot reboot-fastboot:** Reboot headset into Fastboot mode
    * **Fastboot reboot-recovery:** Reboot headset into Recovery mode
    * **Fastboot reboot-bootloader:** Reboot headset into Bootloader mode
  * **Restore screen timeout settings:** Restores default settings.
  * **Creating a shared resource on PC:** Automates the process of creating a shared directory on the computer for access from the headset to this network resource. Connection to this resource is made like a regular network disk (see Google).
  * **Checking USB cable functionality:** USB cable test from PC to headset with test results output for each pass and data transfer speed.
  * **Camera functionality check (Quest 2 only):** Displays temperature of four external headset cameras. Any malfunction can be identified by temperature difference.
  * **Measuring Wi-Fi speed between headset and PC:** The built-in **Wireless Connect Tester** utility performs Wi-Fi speed testing. It displays the IP addresses of both the headset and the PC, allowing users to manually specify the PC's IP address if it is incorrect. Users can define the interval between checks (in milliseconds) and the test duration (in seconds).  
The test consists of two parts: **direct** and **reverse**. Results are saved in both text and CSV formats, enabling visualization through Excel charts. After the test, a **preliminary simplified analysis** is performed. Additionally, users can conduct a more detailed analysis at any time using the CSV files via a separate option in the testing menu.  
For ease of use, a **simplified Auto Test mode** is available, which runs the test with default settings at the press of a single button.  
 Available Options:  
- **Wi-Fi Speed Auto Test with Default Values:** Quick test launch with pre-configured parameters:  
    - Check interval: **100 ms**  
    - Test duration: **180 seconds per test**  
    - Number of threads: **1**  
- **Standard Wi-Fi Speed Test with Custom Values:** Users can manually set test parameters such as duration, interval, and the number of threads.  
- **Analyze Test Results:** Identifies **connection drops** using CSV files.  
- **Additional Explanations on Tests, Errors, Logs, etc.:** Provides detailed help on test options and parameters.  
- **Firewall Management in Case of "Bad File Descriptor" Error:**  
  - **Disable Firewall**  
  - **Enable Firewall**  
  - **Open Port 5201 in Firewall** (Add rule)  
  - **Close Port 5201 in Firewall** (Remove rule)
  - **Check port 5201** (only Windows 10 and above)
- **Service Connection Check:** A quick **5-second** connectivity test.  
- **Launch iperf Server as a Separate Process:** Starts the iperf server and waits for client connections.
- **Set C:\Temp as the iperf server launch directory** Changing the Startup directory of iperf if there are problems when starting testing

**Illustration of test results:** 

![](https://i.ibb.co/b3qStnr/wftesteng.jpg)

  * **Network Connection Statistics (netstat):** Displays comprehensive network connection statistics for the headset. This option helps determine whether the headset has access to Meta servers for firmware updates and App Library. (see Google - netstat)
  
  * **Display Diagnostics:** Testing displays, two variants.
  
  * **Computer Parameter Management: GPU Scheduling, Hardware Acceleration, and Game Mode Management.** Four options are available for each parameter:
    * Show status
    * Enable
    * Disable
    * Delete parameter from registry
   * **Checking Headset Boot Status:** Determines which stage of boot the headset is in or stuck on.
     
   * **Load Monitoring and Component Diagnostics:** Monitors the status and temperature of headset components:
     * Fan status
     * Fan speed
     * Fan warnings
     * CPU temperature
     * GPU temperature
     * Battery temperature
     * Case temperature
     * USB Cached temperature
     * USB Cached conn temperature
     * USB HAL temperature
     * USB HAL conn temperature
     * CPU workload level
     * GPU workload level
     * CPU load
  
  Monitoring interval can be set manually. Monitoring results can also be saved to a CSV file.

* **Additional Options:**
    * **Change Username:** Changes the global username in native headset games.
    * **Show Hidden Settings:** Displays hidden advanced settings on the headset.
    * **Fix OpenSSL SHA Crash Bug:** On Intel processors starting from the 10th generation, there's a bug causing many games on certain Unreal Engine versions to crash or not start. This option fixes the bug.
    * **Restart Oculus Service on PC:** Sometimes it's necessary to restart all services, and to avoid navigating through Windows settings, you can use this option.
    * **Open VPN Settings on the headset:** Opens VPN settings on the headset for easier access.
    * **Set High Priority to Oculus Services:** Sets high priority to Oculus services.
    * **Comprehensive Installation of Oculus Wireless ADB Application:** Manages the headset via ADB directly within the headset, without using a computer.
    * **Registry Key Management for Application Startup:** Saves program startup keys to the registry. Currently only one key is available - "Bybass". It allows skipping initial checks when starting the program and does not display the information table, saving significant startup time - approximately one and a half seconds. The key can be deleted from the registry at any time or re-entered. If the key is set, a small status indicator of the headset will be displayed in the upper left corner of the program. Description of indicators can be found at the beginning of this instruction. 
    * **Social Platform Application Management:** Enables and disables social platform applications (People, Horizon World, etc.)
    * **Solution to the problem with fba files** fba files are created by the RemoteDesktopCompanion.exe process, which is responsible for the connection of the Remote Desktop application on the headset.
This application is from Meta, and if you do not use it and do not plan to use it in the future, it can be safely disabled.
The procedure will temporarily stop the Oculus service, rename the file RemoteDesktopCompanion.exe to RemoteDesktopCompanion.exe.old, and restart the service. It will also delete all fba files in the root of the C drive and in the directory %USERPROFILE%\AppData\Local\Temp
    * **Turn on the screen and disable the proximity sensor** The proximity sensor is disabled and the screen is turned on in permanent mode
    * **Delete old Quas files and directories** Removing old Quas files from the temporary directory

* **Headset Firmware and Firmware Information:**
    * **Fully Automatic Firmware Update:** Headset firmware update is fully automated; just place the firmware file next to the program with any name. Developer mode required.
    * **Button-Based Automatic Firmware Update:** Semi-automatic firmware update option. Same as the previous item, but before updating, boot the headset into Bootloader mode. Developer mode not required.
    * **Extract Firmware Download Link and Download Firmware Files:** Extracts links (if multiple) to firmware from the headset, saves them to a text file, and downloads the firmware files.
    * **Extract Firmware Download Link Only:** Extracts links (if multiple) to firmware from the headset and saves them to a text file.
    * **Download Different Firmware Versions:** Opens a browser with the website address where you can get the latest firmware versions.
    * **Show Current Headset Firmware Version and Check for Updates:** Displays the current headset firmware version and if this version is not up-to-date, a message will be displayed.
    * **Firmware Analyzer:** Checks the firmware file for correctness and compatibility. Provides all information about the firmware file: full or incremental, in the latter case, it will report the firmware version for which the increment is intended. Shows environment version, firmware version, headset model, checks file integrity, and compatibility with the current headset firmware version. As a result, it provides a summary whether this file will be flashed. For a complete analysis, the computer must have internet access. Otherwise, information will be limited to the firmware environment version.
* **Additional explanations about incremental firmware updates:**
  * **Analyzer result for full firmware file:** 

![](https://i.ibb.co/16v00FH/fwfulleng.jpg)


  * **Analyzer result for incremental firmware file:** 

![](https://i.ibb.co/crGNZtn/fwincreng.jpg)

* **Download/Update Progress, DNS Setup:**
  * **View Download Progress:** Displays download progress status in percentage. Progress can be updated manually or automatically with a set interval.
  * **Write DNS Servers to headset:** Sequentially sets DNS servers from a list of 97 DNS servers into the headset. Each subsequent server is set after pressing a button.
  * **Automatic DNS Selection for Update Downloads:** Automatically cycles through DNS servers. The headset automatically sets DNS servers from the list and checks the availability of update addresses after each server.
  * **Reset headset DNS Settings to Default:** Resets settings to default.
  * **Set DNS Internet Placeholder:** Sets DNS server address to 127.0.0.1.
  * **Check Update Availability on PC:** Automatically checks the Meta update server address on the PC and displays a message indicating availability.
  * **Check Update Availability on headset:** Automatically checks the Meta update server address on the headset and displays a message indicating availability.
  * **Check the current DNS server:** Display the DNS server registered in the headset

* **App Operations:**
  * **Launch Quest Install Director Utility:** Comprehensive utility for installing applications individually or in batches - by files and directories.
  * **Run Applications on headset:** Launch certain applications like VPN clients, etc.
  * **Find Command to Launch Application on headset:** Provides application name, package name, and command to launch the application from PC to headset via ADB.
  * **Display and Save List of Installed Applications:** Displays a list of installed applications with names or only with package names. Application list categories include:
    * All
    * System
    * Third-party
    * Disabled
    * Enabled
    * Filtered by name or part of the application name.
  * **Manage Selected Applications:** Manage applications from the selected category. Displays a list of selected applications and allows the following actions:
    * Application Backup:
      * Full Backup
      * Data-only Backup
      * APK-only Backup
      * APK and OBB Files Backup
    * Application Data Restore (under development)
    * Clear Application Data
    * Uninstall Application from headset
    * Launch Application on headset
    * Stop Application
    * Disable Application
    * Enable Application
    * View Application Status:
      * Installed/Not Installed
      * Hidden/Visible
      * Paused/Running
      * Launchable/Not Launchable
      * Enabled/Disabled
      * Instant/Non-instant
      * Virtual/Physical
  * **Install VPN Clients and Oculus Drivers:** Installs VPN clients and Oculus drivers on PC for Win7 and Win10. Driver version selection is automatic depending on the operating system. VPN clients available for installation include:
    * Ultrasurf
    * Winscribe
    * OpenVPN Connect
    * OutlineVPN
    * AdGuard VPN
    * Shadowsocks
    * Psiphon VPN
    * Proton VPN
    * Free VPN Planet
    * v2rayNG
  * **Install Media Applications:** Installs media players, online cinemas, and torrent clients for online viewing. Installed applications include:
    * Skybox VR Video Player
    * Moon VR Video Player
    * 4XVR Video Player
    * Pigasus VR Video Player
    * HereSphere VR Video Player
    * VLC Media Player
    * TorServe
    * Filmix UHD (Online Cinema)
    * Cinema HD (Online Cinema)
    * Cast Receiver
  * **Install Utility Applications:** Installs utility applications such as file managers, browsers, launchers, etc. Installed applications in this category include:
    * VRComm mobile client: Mobile client for access to vrcpmm.ru website
    * LightningLauncher: Launcher with wide capabilities for the headset
    * File Manager+: Convenient file manager for the headset
    * XR File Manager: headset file manager, replaces built-in Files with ability to write to Android/data directory
    * XR Native File Manager:  headset file manager, replaces built-in Files with ability to write to Android/data directory
    * Bugjaeger Premium: Service program for managing headset via ADB from within the headset
    * Termux: Service program for Linux console commands
    * Oculus Wireless ADB: Program for accessing headset via wireless ADB
    * RCX: Program for downloading unofficial content directly on the headset
    * TotalCommander: Dual-panel file manager for the headset
    * SH Script Runner: Creating and running scripts on the headset
    * ADB GUI Tool: ADB work on the headset
    * OVR Metrics Tool: Diagnostic program for headset from Meta
    * Internet Speed Meter: Internet speed testing on the headset
    * Script Manager: Creating and running scripts on the headset
    * Passthrough cam tool: Enabling camera pass-through mode even when Guardian is disabled
    * App Cloner: Application cloning program
    * Apk Tool M: Application cloning program
    * MPatcher: Application cloning program
    * Private Quest (only for smartphones): Service program for headset access and enabling Developer Mode
    * Steam Link: Steam client for wireless headset connection to PC
    * Auto Start Apps Manager: Managing application auto-start

* **CPU/GPU Level Installation:** Install seven CPU/GPU performance levels and display current levels.
* **Setting Native Refresh Rate and Display Resolution:** Allows setting increased display resolutions compared to default to enhance image clarity. It also allows changing the refresh rate. List of installed resolutions:
  * 845 x 768
  * 1127 x 1024
  * 1408 x 1280
  * 1584 x 1440 (Default for Meta Quest 2)
  * 1690 x 1536
  * 1760 x 1680 (Default for Meta Quest 3)
  * 1920 x 1800 (Default for Meta Quest Pro)
  * 1971 x 1792
  * 2253 x 2048
  * 2816 x 2560
  * 3097 x 2816
  * 3380 x 3072
  * 3661 x 3328 [EXP] (Only for Meta Quest 3/Pro)
  * 3942 x 3584 [EXP] (Only for Meta Quest 3/Pro)
  * 4224 x 3840 [EXP] (Only for Meta Quest 3/Pro)
  * 4506 x 4096 [EXP] (Only for Meta Quest 3/Pro)

* **Managing Oculus Link/Airlink:** Options in this category include:
  * Start Oculus Link
  * Disconnect Oculus Link
  * Enable AirLink
  * Disable AirLink
  * Fix Airlink Connection Issue: Deletes Airlink pairing parameters on PC
  * Backup Airlink Connection Parameters: Archives registry parameters and Airlink pairing files on PC
  * Clean up leftovers from computer after removing Oculus software: Deletes all debris left on PC after removing Meta Quest Link
  * Calculate Dynamic Bitrate Values for Oculus Debug Tool: Computes Dynamic Offset and Dynamic Max values for desired maximum and minimum dynamic bitrates
  * Reset Oculus Debug Tools settings to default
  * Download and Run Meta Quest Link Oculus Software Installer: Downloads OculusSetup.exe and runs it.

* **Creating Shortcuts for File Copying and Application Installation:** Launches the Quest Context Tool program, which allows you to set "Send" shortcuts in the context menu for copying and installing applications. After that, simply right-click on a file, and install it on the headset or copy it to any of the headset directories - Movies, Download, OBB, or root. It can install applications using the install.txt script, which is usually located in the game directory, and standard installation - apk and obb. Batch installation is also available - if you right-click on a directory with games, all of them will be installed sequentially. During installation or copying, a detailed and understandable installation or copying log is displayed. After installation, it displays a list of installed and not installed applications. Names of the not installed will be saved to file. Built-in usage guide. Options in this menu:
  * **Files on Quest in OBB:** copies files and directories to Android/obb
  * **Files on Quest in Data:** copies files and directories to Android/data
  * **Files on Quest in Movies:** copies files and directories to Sdcard/Movies
  * **Files on Quest in Download:** copies files and directories to Sdcard/Download
  * **Files on Quest in Sdcard root:** copies files and directories to Sdcard
  * **Install APK+OBB:** Installs applications. Batch installation is supported, multiple applications can be selected.
  * **Installation via INSTALL.TXT:** Installation according to the install.txt script in the application directory
  * **Install all shortcuts at once:** Installs all shortcuts at once
  * **Program description (help)**
  * **Delete installed shortcuts and files:** Deletes all installed shortcuts
  * **Manually delete installed shortcuts and files:** If the shortcuts for some reason were not deleted, you can do it manually

* **Adjusting headset Date, Time, and Timezone:** Checks the correctness of the set time, date, and timezone, and if necessary, sets the correct values.

* **App Data Backup:** Saves all information from the `Android/data` directory and copies the archive to PC

* **Streaming Video Transmission to PC:** Operates on the scrcpy program and includes five transmission modes from the headset to the PC - four pre-installed and one manual. The manual mode can be configured independently with seven parameters - Bitrate, FPS, recording to file, sound output, proximity sensor, and video codec. The subprogram can work with pre-installed profiles and includes six integrated profiles - minimum, light, balanced, demo, quality, maximum. Any of these profiles can be selected and immediately started with the transmission. There is also an option to create your own profiles - up to four. They are saved in a separate file and can be loaded as well as integrated ones. In manual mode, there is also an option to save the scrcpy launch string and edit it as needed. Built-in usage instructions.

* **Advanced Commands and Parameters (Help):** Restart as user, restart as admin with UAC prompt, restart as admin without UAC prompt, accelerated Quas start - without table and checks, additional explanation about incremental firmware, enable downgrade installation, enable installation details display, enable installation log file recording, table of headset partitions and their sizes in bytes and gigabytes: Here are these Additional keys and commands:

      h = This is a window (can be typed in the Main menu)
      u = Restart as a user
      c = Restart as an admin with UAC prompt
      a = Restart as admin without UAC prompt
      b = Quick start Quas: without table and checks
      J > A > d = Enable installation with downgrade option
      J > A > v = Enable installation details display
      J > A > l = Enable installation log file recording
      449 = headset partition table and their size in bytes and gigabytes
      103 = headset partition table and their size in bytes and gigabytes

* **Contact the Author:** Links to GitHub, Viarkomm, program description link, and donate via browser or QR code.

* **Open cmd console:** Opens the Windows command line console in a separate window.

* **Open adb shell console:** Opens access console to the headset

* **Help with problem solving:** Opens websites in the browser where you can get help or read instructions for solving various problems

----------------------
#### Contact me:

- ![itch.io - Quest ADB Scripts)](https://i.ibb.co/17kkCvR/itchio.png) [itch.io - Quest ADB Scripts](https://varset.itch.io/quest-adb-scripts)
- ![Discord (Quas Server)](https://i.ibb.co/xJ7H1NH/dl.png) [Discord (Quas Server)](https://discord.gg/GsBh3M5pU5)
- ![Telegram (Quas Group)](https://i.ibb.co/Y0xrjFD/tg.png) [Telegram (Quas Group)](https://t.me/QuestADBScripts)
- ![Telegram (Personal Account)](https://i.ibb.co/Y0xrjFD/tg.png) [Telegram (Personal Account)](https://t.me/Varsett)
- ![Github](https://i.ibb.co/YNcmzmv/gh.png) [Github](https://github.com/Varsett)
- ![FAQ](https://i.ibb.co/1zyzG5L/qa.png) [FAQ](https://rentry.co/quasfaq)
