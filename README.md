[![Donate](https://img.shields.io/badge/Donate-Boosty-orange?style=for-the-badge)](https://boosty.to/varset/donate)

## Quas Toolkit - QUest ADB Scripts

####  Utility - a collection of the most commonly used commands and actions for the headset. It's like a "multitool" for beginners and      beyond. No need to search for and learn adb commands, parameters, and so on. 
#### Just select the desired action from the list.

![](https://raw.githubusercontent.com/Varsett/pictures/main/q700main-eng.jpg)

**Quas Toolkit is a software utility suite that includes tools for working with Meta Quest headsets and other Android devices.**

**Composition of the complex:** 
- **Quas**  
- **Quas Safe Code Manager**  
- **Quas ADB Commander**  
- **Quas Command Shell**  
- **Quas mDNS Connector**  
- **Quas ADB Sender**  
- **iPerf Test Configurator**  
- **iPerf Real-Time Monitor**  
- **iPerf Visual Analyzer**  
- **Multitest Editor**  


**Job Description:**

The Quas Toolkit software suite is designed to help troubleshoot Meta Quest headset issues and simplify the use of many standard commands and actions, both documented and otherwise. It's essentially a multi-tool, a Swiss Army knife for Quest headset enthusiasts and owners.

The main Quas module is written in cmd with some scripting from other languages: VBS, PS, and many separate PowerShell scripts, particularly for displaying graphical windows. The other tools in the suite are written entirely in PowerShell. The application is packaged into an .exe file using the Quick Batch File Compiler. It contains additional tools: fastboot, scrcpy, devcon, 7z, adb, aapt, etc. A full list of contents can be found at [Github](https://github.com/Varsett/Quas).

The program does not need to be installed, just unpack the downloaded archive using applications for working with archives WinRAR, 7z or others, run `quas.vXXXexe` For the selected language, wait a few seconds, and you're ready to go. You can also use certain keys and launch parameters (see the built-in help, item H, or the list of additional commands at the end of this description). Each time you launch Quas, it displays a table with the most important data on the Home screen.

The program's operation is very simple: select a menu item and then either follow the prompts or select the next option. Many options include detailed instructions and explanations.

In addition to the basic data, the information table contains color coding of the most important parameters:

- **Date in the headset**: The correct time will be highlighted **green**, incorrect -**red**.
- **Filling**: If the headset is filled to 90% or more, the value will be **red** colors, by 50% and above, **yellow** Below this -**green**.
- **Connection**: By cable -**green**, Via Wi-Fi -**dark yellow**, double connection -**red**.
- **TEMP variable**: Standard -**green**, non-standard -**yellow**.
- **Battery charge level**: Below 15% -**red**, below 50%**yellow**, everything above -**green**.
- **Run with privileges**: On behalf of the admin -**green**, on behalf of the user -**yellow**.
- **Update status**: Included -**green**, turned off -**yellow**.
- **Headset charge status**: Charging -**dark green**, Full -**green**, Discharge -**dark yellow**, no charging -**red**.
- **Charging the controllers**: Below 15% -**red**, below 50%**yellow**, everything above -**green**.
- **Drivers**: Current –**green**, Obsolete –**yellow**.
- **Bluetooth**: On –**green**, Off -**yellow**.

All colors are selected according to the following logic:

**Green**: standard and optimal status  
**Dark yellow**: attention may be needed in one case or another  
**Yellow**: there is something to pay attention to  
**Red**: be sure to pay attention  

The program has built-in color (only for Win 10 and above) and letter markings indicating the headset's mode or status. These markings are displayed in the upper left corner of the program and are conveniently used with the b parameter (the Bypass Info Table key), which hides the information table to speed up program launch.

The program has several more registry keys, their descriptions can be found below, in the Additional Options - Managing Registry Keys for Application Launch section.

List of indicators and what they mean:

  * NA - **Not Available** - Device not connected
  * DR - **No Driver**s - headset connected, but drivers not installed
  * CB - **Cable** - Device connected via cable
  * DB - **Doublc connection** - Double connection, via cable and Wi-Fi
  * WL - **Wireless connection** - connected via Wi-Fi
  * DV - **No Developer** - Developer mode not enabled
  * AU - **No Authentication** - headset not authenticated
  * SL - **Sideload mode** - headset in Sideloader mode
  * BL - **Bootloader mode** - headset in Bootloader mode
  * NS - **Not Support** - Connected device is not a headset.
  * NO - **No checks** – All initial checks are disabled.  
  * EM  - **EDL Mode** – The device is in Emergency Download Mode.  
  * OF - **Power Off** – The device is turned off.  
  * DG - **Diag mode** - The headset in Diagnostic mode
  * MT - **MTP mode** - The headset is in MTP mode and may not be available via ADB

**Features and list of options:**

- **Direct access to Android settings:** Allows direct access to hidden Android settings:
  - General settings
  - System
  - For developers
  - VPN settings
  - Adding a Wi-Fi network
  - Date and time
  - Memory usage by applications
  - Bluetooth
  - Data saving mode
  - Saving battery life
  - Location
  - All applications 1
  - All applications 2
  - Notifications
  - Confidentiality
  - Security and privacy
  - Storage
- **Sending text to the headset:** Send any text from your PC to the headset's input field, such as a browser address, a VPN client key, or a login/password to the appropriate fields. Multi-line input is supported.

**_Quas ADB Sender - Main Window_**:
![](https://raw.githubusercontent.com/Varsett/pictures/main/ADBProSender.jpg)

- **Installing Meta Quest drivers:** Automatic installation and download of drivers of various versions.
  - Install version 1.71 (Old Oculus drivers)
  - Install version 1.72 (New Reality Labs drivers)
  - Install version 1.77 (Reworked Reality Labs drivers)
  - Download version 1.71
  - Download version 1.72
  - Download version 1.77
- **Reboot into different modes and information about the current one:** Reboot modes:
  - Resuming the headset boot from Bootloader mode
  - Standard/regular headset reboot.
  - Rebooting the headset into Bootloader mode
    
    **_Illustration of the headset information output in Bootloader mode_**
    ![](https://raw.githubusercontent.com/Varsett/pictures/main/bootloader-eng.jpg)

    - The following functions are available in Bootloader mode:
      - **Collection and display of information**, including:
        - Status and condition of loading slots
        - Headset revision number
        - Headset model
        - Current headset firmware version
        - Headset environment version
        - Battery charge level
      - **Control all headset sensors:**
        - Disabling sensors
        - Enabling sensors
  - Reboot the headset into Recovery mode
  - Rebooting the headset into Fastboot mode
  - Resetting the headset to Sideload mode (normal option)
  - Resetting the headset to Sideload mode (alternative option)
  - Determine the current headset mode
  - Turn off the headset



Firmware information, etc., will allow you to determine the current state of the headset. Disabling sensors can help boot into the environment if the headset fails to boot due to sensor or sensor service failure. If the shutdown is unsuccessful, a message will be displayed.

- **Taking screenshots of the headset display**: Create headset screenshots in three different variations:
  - Single
  - A series of screenshots (each screenshot is taken at the press of a key)
  - Automatic, at a specified interval. The interval between screenshots can be set manually.

Screenshots are copied to the PC desktop in the Screenshots directory.

- **Copying screenshots from the headset to a PC:** Copy all screenshots and video shots from your headset to your PC's Quest Media folder on your desktop. If this folder doesn't exist, it will be created. Two folders will also be created within it: Screenshots and Videoshots.
- **Connecting the ADB headset via Wi-Fi:** In this mode, you can use ADB commands or Quas without using a USB cable. This option only works until you reboot or while a process is running on your PC.**adb.exe**Contains two connection types: via the standard port 5555 and via the TLS encryption protocol.
  - Connect via standard Wi-Fi
  - Connect to Wi-Fi via TLS
  - Connecting via mDNS
    - Automatic connection of the headset to the PC via TLS via mDNS
    - Launching the graphical mDNS parameter configurator
    - Determine IP and port without connection
    - mDNS port listener
    - Restarting the ADB server
    - Viewing mDNS packet dumps
    - View network adapters
    - View ADB version
    - View diagnostic data
    - Manually entering the addresses of the headset and PC for connection
    - Description of options
- **Reconnecting the ADB headset via cable:** Switch to using ADB via cable, for example for copying large files.
- **Connecting the headset as a removable drive:** In some cases, the PC won't mount the headset as a removable drive. This option allows you to forcefully resolve this issue.
- **Managing headset and PC services:** Enable and disable various services, as well as view their status. The list of managed services in this menu:
  - Update management
  - Wi-Fi control on the headset
  - Security System Management
  - Proximity sensor control
  - Bluetooth control on the headset
  - Flight Mode Control on the Headset
  - Controlling ADB Wi-Fi over TLS (Wi-Fi Debugging)
  - Managing Device Storage Monitor
  - Manage GPU Scheduling, Hardware Acceleration, and Game Mode settings
  - Restarting the ADB server on your PC
- **System information:**
  - **Working with dumpsys:** saving a full dump or a list of services, searching by dump.
  - **Memory analyzer.** Options for checking and diagnosing memory occupied by applications. Contains the following items:
    - **Total memory load.** Displays summary data on the device's RAM status: total RAM, how much is in use, and how much is free. This option is useful for quickly assessing system load.
    - **Memory usage by application.** Displays a list of processes and applications, indicating the amount of memory they are using. You can choose to display only system or user processes, and also display a list of the most memory-intensive applications. This feature is used to find memory-hungry processes and analyze which processes are consuming the device.
    - **Real-time memory monitoring (with parameter query)**
    - **Real-time memory monitoring (with automatic parameters).** These options monitor application memory usage. They also write data to a CSV file for further analysis, display memory dynamics in the console, and allow you to set the update interval and number of snapshots. These options are used to track memory changes and detect leaks.
  - **Save all headset properties to a file (getprop)**
  - **Show the headset's IP address:** Display the current IP address of the headset
  - **Save a list of installed packages (packages names):** Saved in short and full format in text files.
  - **Show headset serial number:** Shows the serial number of the headset
  - **Headset system settings (setting list system/global/security):** Saves each section to a text file
  - **Working with Logcat:** Logcat storage for a specified time or volume can be manually configured. Logcat search is also available during log collection.
  - **Battery information:** Displays remaining, lost, learned, estimated, and standard capacity. Shows battery degradation percentage, status, and health. Saves additional data to a file.
  - **List of running applications:** Shows and saves lists of running user or system applications
  - **Extracting a bug report:** Extracts a bug report
  - **View CPU-intensive applications:** Displays a list of the most resource-intensive applications
  - **List of files/directories and their size:** Displays a list of available files and directories, indicating their size.
  - **Show the amount of space used:** Shows the total amount of memory, as well as how much is used, how much is free, and the percentage of memory used.
  - **Log of connections and disconnections of USB devices:** Saves Windows events related to USB cable disconnections and connections to a file, along with the date and time of the events. This is used to diagnose problems with headset disconnections from the PC.
  - **Information about controllers:** Shows information about each controller: Firmware version, Battery level, General status, Positional tracking, IR LED level.
  - **Saving all system information in bulk into one archive:** Saving full information about the headset - system, global, security, bugreport, dumpsys, etc.
  - **Viewing ADB logs**
  - **Viewing Update Engine logs**
- **Diagnostic information** Designed to collect and send information about the headset and PC to aid in problem analysis. Includes the following items:
  - **Summary diagnostic information.** Brief but most important information.
  - **Information about all computer devices.** All information about the hardware displayed in Device Manager. The following data is collected:
    - Device name,
    - Hidden or not,
    - Are the drivers installed or not?
    - VID, PID,
    - Manufacturer,
    - Hardware IDs
  - **Information about installed devices on the computer.** Information only about those devices that do not have drivers installed
  - **Information about Quest headsets only.**
  - **Collection and sending of complex information.** Collects and sends summary information about the headset.
  - **Send any file for diagnostics.** Simple and convenient submission of any file for analysis.
- **Testing, diagnostics, and troubleshooting:**
  - **Restarting the shell and virtual environment of the headset.** Contains the following items:
    - **Restarting the headset shell:** Allows you to solve the problem of dark screen
    - **Restarting the headset shell (second option):** An alternative version of the previous point
    - **Restarting the headset shell (third option):** An alternative version of the previous point
    - **Restarting the headset shell (fourth option):** An alternative version of the previous point
    - **Forced start of the headset's home environment (first option):** Allows you to exit to the Home (Virtual) environment when the screen goes dark. Similar to the Home button on Android devices.
    - **Forced start of the headset's home environment (second option)**
    - **Force launch of the bottom application panel (enable the old interface)**
    - **Enable old interface (only for firmware versions below v2.0.7)**
  - **Interactive test of the headset connection to the PC:** Allows you to monitor in real time the moments of connection and disconnection of the cable from the PC to the headset.
  - **Fix the problem of rebooting with volume buttons (remove KeyMapper):** Uninstalls the program KeyMapper, which is not removed in the usual way.
  - **Integrate ADB and the utility package into the system, and also remove all this junk from it:** Copies multiple files to the system directory for use with adb without requiring you to specify the path to the adb, fastboot, etc. files.
  - **Executing Fastboot commands.** Includes the following commands:
    - **Fastboot devices**: Checking device availability
    - **Fastboot oem device-info**: Collect and save device OEM information
    - **Fastboot getvar all (bootloader)**: Collect and save all possible device information in Bootloader mode
    - **Fastboot getvar all (fastboot)**: Collect and save all possible device information in Fastboot mode
    - **Fastboot continue**: Continue loading the headset
    - **Fastboot reboot-fastboot**: Reboot the headset into Fastboot mode
    - **Fastboot reboot-recovery**: Reboot the headset into Recovery mode
    - **Fastboot reboot-bootloader**: Reboot the headset into Bootloader mode
  - **Restore screen timeout settings:** Restores default settings
  - **Deauthorize the headset on the current PC (remove ADB keys)**
  - **Checking the cable's serviceability:** A USB cable test from a PC to a headset, displaying test results for each pass and the data transfer rate for that cable. The number of passes can be manually set.
  - **Checking the cameras for proper operation:** Searches the headset logs for errors accessing cameras and displays the numbers of such cameras.
  - **Measuring Wi-Fi speed between the headset and PC:** The built-in Wireless Connect Tester utility launches, testing Wi-Fi speeds. It displays the IP addresses of the headset and PC, and allows you to specify your own IP address for the PC if it's incorrect. You can specify the interval between tests (in milliseconds) and the test duration (in seconds). Two tests are performed: forward and reverse. The results are saved to a text and CSV file, which can be used to create a chart in Excel for visualization. After completing the tests, a preliminary simplified analysis of the results is performed. You can perform the analysis at any time if the CSV files are available; this is handled by a separate option in the testing menu. A simplified testing option, Autotest, is also available, which sets default values ​​and runs the test with essentially a single button press. Contains options:
    - **Auto Wi-Fi speed test with default values:** Quick test launch with preset parameters: 100 ms interval between tests, 180 seconds duration for each test, 1 thread. A more detailed description and instructions for all items in this menu can be found in the program.
    - **Advanced settings and testing parameters.** Allows you to run several tests in a row with different interval, stream, duration and bitrate values for each test.
      - **Standard Wi-Fi speed test with a choice of values**
      - **Advanced real-time graphics testing with iPerf Test Configurator**
      - **Automatic selection of the maximum bitrate with zero packet loss**
      - **Launch iPerf Visual Analyzer**
      - **Assign a label (prefix) to the archive name for test results**will allow you to assign an identifier that will be written to the test archive name and saved on the screenshot with the tests.
      - **Assign a label (prefix) to the archive name for test results and backup the results**
      - **Switch TCP/UDP protocols**
      - **Additional explanations of menu options**
    - **Analyze the test results:**(Tabular version) drawdown analysis based on csv files.
    - **Analyze the test results:**(Graphical version) Drawdown analysis using iPerf Visual Analyzer
    - **Plot a histogram or calculate a trend based on test results:** Plotting a diagram.
      - Histogram of the results of the reverse check (console)
      - Direct Test Results Histogram (Console)
      - A graphical diagram of the results of a direct reverse comb test. The diagram displays the bitrate percentage graph over the main bitrate diagram. This allows for a more visual representation of dropout levels.
      - Graphical diagram of the results of direct reversal testing without a "comb"
      - Calculating a trend based on the results of a reverse check. All test results are analyzed to determine whether the bitrate is increasing or decreasing over the course of the test. This is probably a complete nonsense, but it offers a chance to detect a decrease in router throughput, for example, if it's overheating.
      - Calculating a trend based on direct verification results. Same as above, but for direct verification.
      - How to create a chart in Google Sheets (instructions). Instructions on how to quickly and easily create a chart in Google Sheets based on test results.

    **_Illustration of the constructed histogram_**
    ![](https://raw.githubusercontent.com/Varsett/pictures/main/histo.jpg)

    **_Illustration of a graphical diagram_**
    ![](https://raw.githubusercontent.com/Varsett/pictures/main/diagramm.jpg)

- **Troubleshooting connection and test launch issues** - **Working with the firewall when the "Bad file descriptor" error occurs** - Disable the firewall - Enable firewall - Open port 5201 in Firewall (add a rule) - Close port 5201 in the firewall (delete the rule) - Check if port 5201 is open or closed (Windows 10 and above only) - **Service connection check** Quick connection check, test duration 5 seconds. For connection testing only! NOT FOR TESTING! - **Run iperf server as a separate process** The iperf server starts and waits for a client connection. - **Temporarily set C:\\Temp as the iperf server startup directory.** This option is useful when the iPerf server starts, but a connection fails due to insufficient access rights. In this case, you can try setting the iPerf server startup directory to C:\\Temp. This will cause the server to start from C:\\Temp instead of the usual user's temporary directory. The current startup directory will be displayed on the testing page. - **Write the C:\\Temp directory to the registry and make it permanent** the same as in the previous paragraph, only the iperf startup directory is not reset after exiting the program. - **Grant full access rights to the C:\\Temp directory** - **Switch TCP/UDP protocols** - **Additional explanations of menu options:** help with testing options and parameters

  **_Illustration of test results_**  _(tabular version)_
![](https://raw.githubusercontent.com/Varsett/pictures/main/WiFiTestRezult-eng.jpg)

    **_Multitest Editor_**  
![](https://raw.githubusercontent.com/Varsett/pictures/main/Multitest.jpg)

**Brief description of features:**

- Creating a set of iPerf3 tests
- Editing multiple tests in one window
- Unlimited number of lines
- Enable/disable individual tests
- Names/Labels for each test
- Setting parameters:
     - Interval
     - Streams
     - Duration
      - Bandwidth
      - TCP/UDP
 - Manual editing mode for individual lines
 - Adding new tests
 - Deleting tests
 - Validation of numerical parameters
 - Checking acceptable ranges
 - Specifying the number of the erroneous line
 - Indicating the Label of an erroneous test
 - Detailed error messages
 - Saving to multitest.txt
 - Loading an existing multitest.txt
 - Reload configuration
 - Automatically create Test1 if file is missing
 - Integration with CMD/BAT testing engine
 - Status bar with operation time

   **_iPerf Configurator_**  
   ![](https://raw.githubusercontent.com/Varsett/pictures/main/iPerfConfigurator_v1.52.jpg)

**Brief description of features:**

- Creating iPerf3 profiles
- Editing profiles
- Renaming
- Removal
- Enabling/disabling profiles
- Multiple profile storage
- Saving profiles to INI
- Loading profiles from INI
- Reload without restarting the program
- Tracking unsaved changes
- Confirm save before launch/exit
- Automatic local IP detection
- Manual IP change
- Configuring iPerf3 parameters:
     - Host/IP
     - Port Configuration
     - TCP/UDP
     - Direct/Reverse
     - Bitrate
     - Duration
     - Interval
     - Buffer Length
     - Streams
     - Socket Buffer
     - TCP_NODELAY
 - Additional iPerf3 parameters
 - Enable/disable individual parameters via manual
 - Automatic value suggestions
 - Ready-made templates:
     - Virtual Desktop
     - Air Link
     - Steam Link
     - ALVR
     - UDP 0 Mbps
     - UDP 600 Mbps
 - Custom mode
 - Integration with an external CMD/BAT test engine
 - Integration with iPerf3 Real-Time Monitor

**_iPerf Real-Time Monitor_**
![](https://raw.githubusercontent.com/Varsett/pictures/main/iPerf3-RealTime_v2.81.jpg)

**Brief description of features:**

- Launching iPerf3 via ADB
 - TCP testing
 - UDP testing
 - Direct/Reverse mode
 - Display parameters:
     - Bitrate
     - Duration
     - Interval
     - Streams
     - Buffer length
     - Socket window
 - Passing additional iPerf3 parameters
 - Get results in real time
 - Bitrate Live Chart
 - Jitter Live Chart
 - Packet Loss Live Chart
 - Separate scales for each graph
 - Average Bitrate Line
 - Automatic calculation of Min/Max/Avg
 - Average and Maximum Packet Loss
 - Average and Maximum Jitter
 - Threshold for Bitrate
 - Packet Loss Threshold
 - Threshold for Jitter
 - Color indication of problems
 - Changing window color when packet loss is high
 - Autoscroll
 - View full history
 - Toggleable legend
 - Monitoring the CPU of iPerf3 itself
 - Automatic CPU load assessment
 - Warning about too high CPU load
 - Export results to CSV
 - Saving a full window as PNG
 - Integration with Visual Analyzer
 - Transferring CSV to Visual Analyzer
 - Passing additional parameters to Visual Analyzer
 - Automatic termination of iPerf3 server
 - Automatically close the GUI
 - Configurable delay before closing
 - Automatically clean/close resources on exit
 - A large number of command line options

    **_iPerf Visual Analyzer_**
    ![](https://raw.githubusercontent.com/Varsett/pictures/main/iPerf3VisualAnalyzer.v3.47.jpg)

**Brief description of features:**

 - iPerf3 Log Analysis
 - Support for TXT, LOG, and CSV
 - Real-Time Monitor CSV Analysis
 - Plotting speed, loss, and jitter graphs
 - Displaying multiple tests simultaneously
 - Automatic calculation of statistics
 - Color indication of connection quality
 - Automatic generation of the final conclusion (Verdict)
 - Scaling and scrolling charts
 - Turning individual data series on and off
 - Export results to CSV and PNG
 - Saving interface screenshots
 - Light and dark themes
 - Support for command line parameters
 - Automatic detection of test parameters (TCP/UDP, duration, number of threads, intervals, etc.)
    
- **Network connection statistics (netstat):** Displays complete network connection statistics for the headset. This option lets you determine whether the headset has access to Meta servers for firmware, updates, and the Application Library. (See Google - netstat)
- **Display diagnostics:** Display testing, two options.
- **Checking the headset download status:** Determines which loading stage the headset is in or is stuck in.
- **Load monitoring and component diagnostics:** Monitoring the condition and temperature of headset components:
     - Fan status
     - PWM fan status
     - Fan speed
     - Fan warnings
     - CPU temperature
     - GPU temperature
     - Battery temperature
     - Case temperature
     - Temperature USB Cached
     - Temperature USB Cached conn
     - Temperature USB HAL
     - Temperature USB HAL conn
     - CPU performance level
     - GPU performance level
     - CPU load

The monitoring interval can be set manually. Monitoring results can also be saved to a CSV file.

- **Memory usage information**
- **Real-time CPU monitoring**
- **Additional options:**
  - **Change username:** Changes the global username in native headset games.
  - **Show hidden settings:** Display hidden advanced settings in the headset.
  - **OpenSSL SHA Crash Bug Fix:** There's a bug on Intel processors starting with the 10th generation that causes many games to crash or fail to launch on certain versions of the Unreal Engine. This option fixes the bug.
  - **Restarting the Oculus service on PC:** Sometimes you need to restart all services, and to avoid having to navigate through the depths of Windows settings, you can use this option.
  - **Open VPN settings in the headset:** For more convenient access to VPN settings
  - **Set Oculus services to high priority:** Set higher priority for Oculus services.
  - **Complete installation of the Oculus Wireless ADB app:** Control the headset via ADB directly inside the headset itself, without using a PC.
  - **Managing registry keys for running an application:** Saving program launch keys to the registry. Four keys are available for use:
    - **Bypass Info Table**It allows you to skip the initial check when launching the program and also not display the information table, which will save a significant amount of time on program startup – approximately one and a half seconds.
    - **Bypass Wireless Warning.** Removes the warning window that the headset is connected via Wi-Fi.
    - **Bypass Initial Status.* *Disables all initial checks.
    - **iPerf Temp Dir**Permanently sets the C:\\Temp folder as the iPerf startup directory. The iPerf server will then only start from this directory.
    - **Backups Dir.** Sets the directory for backups.
    - **Check for the presence of keys in the registry**
    - **Description of keys**
    - **Export the HKEY_CURRENT_USER\\Software\\Quas branch to a file**
    - **Delete all these keys from the registry**

Keys can be deleted from the registry at any time, or registered again.

- **Managing the Social Platform application.** Disabling and enabling social platform apps (People, Horizon World, etc.)
    - **Solution to the problem with fba files:** FBA files are deleted from the root of the system drive, from the Temp directory in the user profile, and from \\Windows\\System32. You can also restrict access to the RemoteDesktopCompanion.exe file for the Meta Link program or create a zero-size placeholder for this file.
    - **Turn on the screen and disable the proximity sensor**
    - **Removing old Quas files and directories:** cleans all temporary directories and files of Quas
    - **Open the hosts file in Notepad:** opens the hosts file in Notepad.**Administrator rights are required to save changes.**.
    - **Find out the pairing code for the mobile application.** Allows you (when the headset is connected) to automatically prompt for a five-digit pairing code for the headset with the Meta Horizon mobile app
    - **Creating a shared resource on a PC:** Allows you to automate the process of creating a shared directory on your PC, allowing you to access this network resource from your headset. Connecting to this resource is done like a regular network drive (see Google).
    - **Disabling and enabling driver signature verification**Allows you to install a driver without a digital signature.
    - **Removing a pattern lock**will help clear the graphic key on the headset if it is forgotten or does not work.
- **Headset firmware and firmware information:**
  - **Fully automatic firmware:** Flashing the headset is fully automated. Simply place the firmware file, no matter the name, next to the program, select this mode, and confirm the flashing process. The entire process will then proceed automatically, with explanations for each step. This option requires Developer Mode.
  - **Push-button automatic firmware:** Semi-automated flashing option. Everything is the same as in the previous step, but before flashing, you should boot the headset into Bootloader mode. Developer mode is not required.
  - **Extract the firmware link and download the firmware files:** Extracts links (if there are several) to firmware from the headset, saves them to a text file, and downloads the firmware itself.
  - **Just extract the firmware link from the headset:** Extracts links (if there are several) to firmware from the headset and saves them to a text file.
  - **Download various firmware versions:** A browser will open with the address of the website where you can download the latest firmware versions.
  - **Show the current headset firmware version and check its relevance:** Displays the current version of the headset firmware and displays a message if this version is not up to date.
  - **Firmware analyzer:** Firmware file verification for correctness and compatibility. Provides full information about the firmware file: full or incremental. In the latter case, it will report the firmware version for which the increment is intended. It will display the environment version, firmware version, and headset model, check the file for integrity, and check for compatibility with the current headset firmware version. Finally, it provides a summary of whether the file can be flashed. For a full analysis, the computer must have internet access. Otherwise, the information will be limited to the firmware environment version only.
  - **Download tables of environment versions corresponding to headset firmware versions:** A table is downloaded for the selected headset model with the environment version number and the corresponding headset firmware version number
  - **Additional clarifications about incremental firmware**
  - **Emergency firmware mode:** Allows you to load the headset into sideload mode when the standard methods for switching to sideload do not work.

**_Result of the Firmware Analyzer:_**
![](https://raw.githubusercontent.com/Varsett/pictures/main/FWanalizeok-eng.jpg)

**_Automatic Flashing Menu:_**
![](https://raw.githubusercontent.com/Varsett/pictures/main/FWflashmenuok-eng.jpg)

- **Download/update progress, DNS setup:** Includes options:
  - **View download progress:** Displays the progress status as a percentage. The status can be updated either manually or automatically, with a configurable check interval.
  - **Recording DNS servers in the headset:** Adds DNS servers from a list to the headset one by one. There are 97 DNS servers in the list; each subsequent one is added after pressing a button.
  - **Automatic DNS selection for downloading updates:** Automatic DNS server selection. The program registers DNS servers from a list in the headset, checking the availability of update addresses after each server. If the update address is unavailable, it automatically registers the next DNS server from the list, and so on until an address becomes available or the list is exhausted.
  - **Resetting the headset's DNS settings to default:** Sets the default DNS server settings.
  - **Disable the frequent DNS server completely**
  - **Install DNS Internet Stopper:** Sets the DNS server address to 127.0.0.1
  - **Checking for updates on your PC:** Automatically checks the Meta server update address on your PC and displays a message indicating whether it is available or not.
  - **Checking for updates on your headset:** Automatically checks the Meta server update address on the headset and displays a message indicating whether it is available or not.
  - **Find out the status of the current DNS server and its address:** displays the address of the DNS server currently registered on the headset.
- **Working with applications:**
  - **Launching the Quest Install Director application installation utility:** a comprehensive utility for installing applications individually or in batches - by files and directories
  - **Launch applications on the headset:** launching some applications: VPN clients, etc.
  - **Find out the command to launch the application on the headset:** allows you to find out the name of the application, the name of its package and the command to launch this application from a PC on the headset via adb.
  - **Display and save the list of installed applications:** Displays a list of installed applications, either with names or with just package names. Application list categories:
    - All
    - Systemic
    - Unofficial
    - Disabled
    - Included
    - Filtered by app name or part of app name
  - **Manage selected applications:** Manage apps from the selected category. Displays a list of selected apps and allows the following actions:
    - **Removing the app from the headset**
    - **Soft removal**(without clearing data and cache)
    - **Clearing data and cache**
    - **Disconnection**
    - **Turning on**
    - **Launch**
    - **Stop**
    - **Restart**
    - **View application status:**
      - Installed/Not installed
      - Hidden/Visible
      - Paused/Running
      - Launchable/Not launchable
      - Enabled/Disabled
      - Instant/Not Instant
      - Virtual/Physical
    - **Viewing applications running on the headset**To view currently running applications, select this option. In the next menu, select 1. All. Then, in the application list, click Select All and Confirm. A list of currently running applications will be generated and displayed on the screen (and also in a file).
    - **Save the list of selected applications to a file**
  - **Installing VPN clients for Android:** Installs VPN clients and Oculus drivers on your PC for Windows 7 and Windows 10. Driver versions are selected automatically based on your operating system. List of VPN clients to install:
    - Ultrasurf
    - Windscribe
    - OpenVPN Connect
    - OutlineVPN
    - AdGuard VPN
    - Shadowsocks
    - Psiphon VPN
    - Proton VPN
    - Free VPN Planet
    - ByeByeDPI
    - v2rayNG VPN
    - v2rayTun VPN
    - Wireguard
    - Kakadu VPN
    - Happ Proxy
    - Karing
    - Amnesia
    - X-vpn
    - Mullvad VPN
    - Hidemyname VPN
    - VPNLY
    - SurfShark
  - **Installing VPN clients for PC**
    - Windscribe
    - OutlineVPN
    - AdGuard VPN
    - Shadowsocks
    - Psiphon VPN
    - Free VPN Planet
    - v2rayTun VPN
    - Wireguard
    - Kakadu VPN
    - Happ Proxy
    - Amnesia
    - Karing
    - X-vpn
    - Mullvad VPN
    - IVPN
    - Hidemyname VPN
    - VPNLY
    - ClearVPN
    - SurfSharl
    - Throne
  - **Installing media applications:** Installing media players, online cinemas, and a torrent client for online viewing. List of installed applications:
    - Skybox VR Video Player
    - Moon VR Video Player
    - 4XVR Video Player
    - Pigasus VR Video Player
    - HereSphere VR Video Player
    - VLC Media Player
    - TorServe
    - Filmix UHD (Online Cinema)
    - Cinema HD (Online Cinema)
    - Cast Receiver
  - **Installing application software:** Installs several applications: file managers, browsers, launchers, etc. List of installed applications in this category:
    - VRComm mobile client: Mobile client for accessing the site [vrcomm.ru](http://vrcpmm.ru/)
    - Lightning Launcher: A powerful app launcher for your headset
    - LightningLauncher (Meta Store)
    - File Manager+: A convenient file manager for your headset
    - XR File Manager: A file manager for the headset, replacing the built-in Files, but with the ability to write to the Android/data directory
    - Shizuku
    - Telegram
    - MT Manager
    - RCX: A program for downloading unofficial content directly to the headset.
    - Total Commander: Two-panel file manager for a headset
    - SH Script Runner: Create and run scripts on your headset
    - OVR Metrics Tool: Meta's Headset Diagnostic Tool
    - Internet Speed Meter: Testing Internet Speed on a Headset
    - Script Manager: Create and run scripts on the headset
    - Passthrough cam tool: A program for enabling pass-through mode for cameras even when the Protective Zone is disabled.
    - App Cloner: A program for cloning applications
    - Apk Tool M: A multifunctional program for working with applications: translation, recompilation, editing the name and title of the application, etc.
    - MPatcher: Application Cloning Software
    - Private Quest (only for smartphones): A utility for accessing the headset and enabling Developer Mode.
    - Steam Link: A Steam client for wirelessly connecting your headset to your PC
    - Auto Start Apps Manager: Manage auto-start apps
    - XR Native File Manager: Allows access to the Android/data and Android/obb directories from the headset
    - Telegram
    - MT Manager
    - Shizuku
    - Lightning Launcher from Meta Store
  - **Installing gaming applications:** A category of programs for downloading games or applications or installing unofficial games and applications. List of applications:
    - qLoader
    - ARMGDDN Browser
    - VRP Essentials
    - YAAS
    - Steam Auto Crack
    - Steam Auto Crack GUI
    - Quest Patcher for Beat Saber
    - APPID
    - PCVR Mods Hub
  - **Installing ADB utilities** Contains a list of utilities for working with ADB. Here's a list:
    - Integrate the ADB package into the system and remove all this junk from it
    - Bugjaeger. A utility for controlling a headset via ADB from inside the headset.
    - Termux
    - Oculus Wireless ADB
    - SH Script Runner
    - ADB GUI Tool
    - Script Manager
    - Meta Quest Developer Hub
  - **Cleaning up unnecessary applications** Allows you to clean your headset of various debris. Options in this menu:
    - Disabling unnecessary applications
    - Removing unnecessary applications
    - Exporting application lists to files from the registry
    - Importing application lists from files into the registry (with adding registry entries)
    - Import application lists from files into the registry (with cleaning of registry entries)
    - Removing lists from the registry
    - Open the registry branch HKCU\\SOFTWARE\\Quas\\
    - Create text files with lists of applications
    - Select and add to the list of applications to be removed
    - Select and add to the list of applications to disable
  - **Installing applications from your own list**
    - Launch QuasSafe Key Manager
    - List the keys in the registry and extract the decrypted Payload
    - Install apps from a custom list (file)
    - Install apps from a custom list (flow)

**_Quas Safe Code Manager - Main Window_**:  
![](https://raw.githubusercontent.com/Varsett/pictures/main/QuasSafeMain.jpg)

**_Quas Safe Code Manager - Key Control_**:  
![](https://raw.githubusercontent.com/Varsett/pictures/main/QuasSafeViewKey.jpg)
  
**Brief description of Quas Safe Code Manager features:**

- Encryption of arbitrary text, passwords, commands and scripts using the AES-256-CBC algorithm.
- Brute-force protection using PBKDF2-SHA256 KDF for 100,000 iterations.
- Verify data integrity and authenticity using HMAC-SHA256 before decryption.
- Using unique random salts (16 bytes) and initialization vectors (16 bytes) for each encryption.
- Storing encrypted entries in the Windows registry.
- Export and import encrypted keys as JSON strings via a text file (vault.txt).
- Export and import the entire database into a single master password-encrypted safe file (vault.enc).
- Securely store passwords in memory using SecureString and immediate cleartext erasure.
- Protection against password guessing using delays (rate-limiting) between input attempts.
- Automatically close the password entry window after 60 seconds.
- Saving decrypted data to a file. Outputting decrypted data directly to the console stream.
- Copy decrypted data to the clipboard with automatic clearing after 30 seconds.
- Automatically launch created files after decryption by bypassing the execution policy for .ps1.
- Copy encrypted data block (Base64) to clipboard for integration into command line and third-party scripts.
- A fully functional graphical user interface (GUI) based on Windows Forms.
- Switch between dark and light interface themes.
- A post editor with field validation and tracking of unsaved changes.
- Built-in interactive help window with highlighted formatted text.
  - **Installing Meta Quest drivers**
    - Install version 1.71 (Old Oculus drivers)
    - Install version 1.72 (New Reality Labs drivers)
    - Install version 1.77 (Reworked Reality Labs drivers)
    - Download version 1.71
    - Download version 1.72
    - Download version 1.77
- **Setting CPU/GPU/Refresh Rate/Resolution/frameSync**
- **Oculus Link/Airlink Controls:** List of options in this category:
  - **Start Oculus Link**
  - **Disable Oculus Link**
  - **Enable AirLink**
  - **Disable AirLink**
  - **Fix Airlink connection issue**: Deletes Airlink pairing settings on PC
  - **Back up Airlink connection settings**: Creates an archive of registry settings and Airlink pairing files on your PC
  - **How to clean up leftovers from your computer after uninstalling Oculus software**: Removes all the junk left on your PC after uninstalling Meta Quest Link
  - **Calculate dynamic bitrate values ​​for the Oculus Debug Tool:**calculates Dynamic Offset Dynamic Max values ​​for the desired maximum and minimum dynamic bitrates
  - **Resetting Oculus Debug Tools to Default Settings**
  - **Download and run the Oculus Meta Quest Link software installer**: OculusSetup.exe is downloaded and launched.
  - **Fix Meta Link software connection error**
  - **Find and display errors in Meta Link installation logs**
- **Create shortcuts for copying files and installing applications:** Launches the Quest Context Tool, which allows you to set shortcuts for copying and installing applications in the "Send to" context menu. Afterwards, simply right-click the file and install it on the headset or copy it to any of the headset's directories—Movies, Download, OBB, Data, or the root directory:

**_Sendto Context Menu_**:
![](https://raw.githubusercontent.com/Varsett/pictures/main/sendto-eng.jpg)

Can install apps using the install.txt script, which is usually located in the game directory. Standard installations include APK and OBB files. Batch installation is also available: right-clicking on the game directory will install all the games one by one. A detailed and easy-to-understand installation or copying log is displayed during installation or copying. Upon completion of installation, it displays a list of installed and uninstalled apps. The names of uninstalled apps are saved to a file. You can also restore data from a backup file from the context menu. It includes a built-in user guide. Options in this menu:
- **Quest Context Tool**
  - **Quest files in OBB:** Copies files and directories to Android/obb
  - **Files on Quest in Data:* *Copies files and directories to Android/data
  - **Files on Quest in Movies:** copies files and directories to SD card/Movies
  - **Files on Quest in Download:** copies files and directories to SD card/Download
  - **Files on Quest in the root of the SD card:** copies files and directories to SD card
  - **Installing APK+OBB:** Installs applications. Batch installation is supported; you can select a directory with multiple applications to install one after another.
  - **Restoring an .ab archive:** Restoring files from a backup to a headset
  - **Installation via INSTALL.TXT:** Installation using the install.txt script in the application directory
  - **Recovering an .ab archive**Restoring backup data
  - **Install all shortcuts at once:** Installs all shortcuts at once
  - **Program description (help)**
  - **Remove installed shortcuts and files:**Removing all installed shortcuts
  - **Manually remove installed shortcuts and files:**If for some reason the shortcuts are not deleted, you can do it manually.

- **Adjusting the date, time, and time zone in the headset:** The function checks the correctness of the set time, date and time zone and, if necessary, sets the correct values.
- **Archiving and recovery:** Creates and restores app data, as well as saves APK and OBB files. Contains the following sub-items:

  - **Backup Application Menu**
    - Selective Backup
    - Backup from List
    - Backup All Applications
    - Backup only Applications with data
    - Description of the functions of this menu

  - **Application data recovery menu**
    - Standard recovery (thorough backup scan)
    - Standard recovery (instant backup scan)
    - Restore with manual backup directory selection
    - Restore with manual backup file selection
    - Restore app data from the current directory only
    - Restore app data from the current directory, including all subdirectories
    - Description of the functions of this menu

  - **Application File Saving Menu**
    - Save all application files (APK+OBB+DATA)
     - Saving APK
     - Saving APK + OBB
     - Saving data
     - Description of the functions of this menu

**Show and create a list of applications**
**Extracting data from a backup file**
**Remove access blocking to save files**
**Set a permanent directory for backups**
**Turn on the proximity sensor**
**Copy or move selected archives to a separate subdirectory**
**Deleting old backups**

This section is designed for archiving and restoring app data, which stores game saves, settings, and other app information. Here you can back up this data for each app and restore it later, for example, after resetting the headset to factory settings. This way, your saves and settings will not be lost. If the data files do not contain saves or they are stored in a different location, the backup will not preserve them.

- **Stream video broadcasts on PC:** It runs on the scrcpy program and offers five modes for streaming from the headset to a PC: four presets and one manual mode. The manual mode can be customized using seven parameters: bitrate, frame rate, file recording, audio output, proximity sensor, and video codec. The program supports preset profiles and offers six built-in profiles: minimal, lightweight, balanced, demo, high-quality, and maximum. You can select any of these profiles and immediately start streaming with it. You can also configure your own profiles—up to four. These will be saved to a separate file and can be loaded in the same way as the built-in profiles. In manual mode, you can also save the scrcpy command line and edit it as needed. It also includes a built-in user manual.

This also includes another broadcasting program, Casting, a separate, independent broadcasting module extracted from the Meta Quest Developer Hub. It broadcasts images in full-screen mode and has a variety of settings, including bitrate, resolution, and more. It also includes the ability to record videos and create screenshots (images).

- **List of advanced commands and parameters(Help):** Restart as user, restart as administrator with UAC prompt, restart as administrator without UAC prompt, accelerated Quas startup - without tables and checks, additional explanation about incremental firmware, enable installation with downgrade option, enable display of installation details, enable logging to the installation log file, headset partition table and their size in bytes and gigabytes: Here are these additional keys and commands:

**Command line options:**
    **h** \= This window (can be typed in the Main menu)
    **u** \= Restart as user
    **c** \= Restart as administrator with UAC prompt
    **a** \= Restart as administrator without UAC prompt
    **b** \= Accelerated start of Quas: without tables and checks
    **v** \= Verbose: Displays full information about the script's operation.
    **f** \= Start Quas with preliminary closing of adb.exe processes
    **qqX** \= Automatic archiving of application data according to the list with number "X"
    **d** \= Collecting and sending diagnostic information


**Additional Main Menu commands:**
    **00** = RebootQuas (works in any menu)
    **G-FF** = Additional clarification about incremental firmware
    **J-A-d** Enable installation of APK applications with downgrade option
    **J-A-v** = Enable display of application installation detailsapk
    **J-A-l** = Enable logging to the application installation log fileapk
    **J-E-dd** = Disabling applications in batches
    **J-E-gg** = Stopping applications in batch mode
    **449** = Headset partition table and their size in bytes and gigabytes
    **103** = Headset partition table and their size in bytes and gigabytes
    **77** = Connecting to a headset via ADB-TLS (similar to FGD points)
    **pt** = Display test resultsWi-Fi from the Diagnostics menu or from the Main menu
    **qqXX** = Quick backup by list number XX
    **s** = Debug information
    **st** = Console windowKvass
    **sa** \= Quick launch of applications
    **adbe** = Quickly integrate the ADB utility into the system
    **adbd** = Quickly remove ADB package from the system
    **adbi** = Quickly integrate the utility package and ADB into the system

- **Search by menu options.** You can search by the names of all Quas program options and menus. The program can search by partial words, and the search is case-insensitive. To save a complete list of all options in a tree view to a file, simply press Enter in the input line.

**_Illustration of search results_**
![](https://raw.githubusercontent.com/Varsett/pictures/main/searchmenu-eng.jpg)

- **Contact the author:**
  - The author's page on Github
  - Viarcomm Community
  - Description of the program
  - Toss a coin: Buy me the coffee \[QR code\]
  - Toss a coin: Buy me the coffee \[Web browser\]
  - Support the project on Boosty \[QR code\]
  - Support the project on Boosty \[Web browser\]
  - Gift a subscription to Claude AI
  - Leave a review or send a file


- **Quas ADB Commander:** Opens the File Manager to copy files from the headset to the PC and vice versa.

**_Quas ADB Commander_**
![](https://raw.githubusercontent.com/Varsett/pictures/main/adbcm104-eng.jpg)

**Brief description of features:**

- Viewing the Windows file system
- Viewing the Android file system via ADB
- Working with applications on Android devices:
  - Select application categories: System, Third-Party, Disabled, etc.
  - List applications by both package names and titles
  - Removing applications
  - Clearing app cache and data
  - Turning on
  - Disconnection
  - Launch
  - Stop (soft or forced)
  - Restart
  - Viewing the status of applications
  - View running applications
  - Saving a list of applications to a file
  - Extract APK/OBB
  - View the full path of an application
- Copying PC → Android
- Copying Android → PC
- Moving files
- Renaming
- Removal
- Creating directories
- Bulk operations with files and directories
- Native clipboard
- Sort by name, size and date
- Recursive file search with transition to the selected file
- Built-in text editor:
  - Automatic encoding detection
  - Support UTF-8/UTF-16/1251/1252/OEM866/ASCII
  - Converting encodings
  - Syntax highlighting
  - Search by text
  - Line breaks
- Installing APK/OBB/XAPK/APKS
- Getting APK information via AAPT2
- Working with archives:
  - Support for ZIP/7Z/RAR/TAR/GZ/BZ2/XZ and other archives
  - Support for multi-volume archives, unpacking from any part
  - Viewing archive contents
  - Unpacking archives on a PC
  - Unpacking archives on Android
  - Creating 7z archives
  - Working with files directly within the archive
  - Editing text files inside 7z and zip archives
- Previewing media files
- Recognition of text, executable, archive, APK, and multimedia files
- Color indication of file types
- Context menu
- Logging and diagnostic mode
- Configurable logging levels
- Quick access to Android Data
- Quick access to Android OBB
- Full bilingual localization in Russian and English
- Stop button for the current action


- **Quas Command Shell:** Opens a command console window. Illustration of the console and its capabilities:

**_Quas Command Shell_**
![](https://raw.githubusercontent.com/Varsett/pictures/main/qcs-607-eng.jpg)

**Brief description of features:**

  - Own tab system
  - Separate log for each tab
  - Create an unlimited number of tabs
  - Each tab contains its own command editor.
  - Each tab has its own log
  - Show the active tab in the status bar
  - Renaming tabs
  - Multi-line editor
  - Support for inserting and editing text
  - Syntax/search match highlighting
  - Counting the number of lines
  - Clipboard (copy/paste)
  - Saving the last state
  - Saving withdrawal history
  - Run entered commands
  - Support for executing ADB commands and other console utilities
  - Tree of ready-made commands (500 pieces)
  - Color classification of dangerous commands
  - Loading commands from the hints.txt file, you can supplement it with your own commands
  - Automatically detect the location of the hint file
  - Command categories
  - Description of each command with usage examples
  - Search the command tree, both in commands and in their descriptions
  - Quickly insert a command into the editor
  - Light and dark themes
  - Full bilingual localization in Russian and English
  - Help in solving problems**:** opens websites in the browser where you can get help or read instructions on how to solve certain problems

Quas has a Diagnostic Mode. To access it, rename quas.. to dquas... , so that the filename begins with the letter d. The following are the options in this mode:

- **Restart to normal mode**
- **Restart and kill adb.exe processes**
- **Launching with checks disabled and without ADB**
- **Embed ADB into the system**
- **Install Meta drivers**
- **Collect and submit diagnostic information**
- **Automatically free up space on your headset**
- **Running Quas in debug mode**


**_Headset not found Illustration_**
![](https://raw.githubusercontent.com/Varsett/pictures/main/q610notfoundeng.jpg)

Download the latest version of the program:<https://vrcomm.ru/files/file/7-quest-adb-scripts-quas/>

**Previous versions of Quas can be downloaded from the following link:**
[**https://k00.fr/quastool**](https://k00.fr/quastool)

**A history of changes and a more detailed description of new and updated features in Google Docs:**
[**https://docs.google.com/document/d/16wE4N1QeHRmGzaBlqfs5tB92h1P5_nexHXKdv6LHka0**](https://docs.google.com/document/d/16wE4N1QeHRmGzaBlqfs5tB92h1P5_nexHXKdv6LHka0)

**Quas app FAQ:**

**Q:My antivirus says the program contains a Trojan or a virus. Why?**

**A:** The program and additional utilities are packaged into a single package using the Quick Batch File Compiler application, which, unfortunately, is often used to package malicious applications. As a result, antivirus programs, upon detecting a familiar packer signature, don't bother checking the contents and immediately flag the package as malicious. You can unpack the Quas package using the standard 7zip archiver and examine its contents, or you can visit [**GitHub**](https://github.com/Varsett/Quas) and view the package contents and source code. Additionally, starting with v3.1.0, the Quas package includes the AndroidMdnsDiscover.exe application, designed to detect the headset via the mDNS protocol and display the headset's IP address and port. A Python script provides the same functionality, which you can view and download here: <https://github.com/thedroidgeek/oculus-wireless-adb/tree/main/script>. Antivirus software also dislikes the packager for this program.

**Q:What is the difference between connecting a headset via Wi-Fi from the main menu (item 7) and connecting a headset via port 5555, FGC items?**

**A:** When it comes to connecting to a PC, there's no difference. However, the second option can also be used to connect directly to the headset from the headset itself, using the same port 5555. You can control the headset internally via ADB using apps like Termux or Bugjaeger. For example, you can change the resolution, refresh rate, or CPU/GPU level. Similarly, you can easily connect the headset to a PC wirelessly using the so-called random port, as long as Quest Games Optimizer is running on the headset.

**Q:Why is the program written in cmd?**

**A:** Because I don't know any other languages, I just needed a utility with a small set of ADB functions so I wouldn't have to manually enter commands every time. I wrote it and decided to share it. But over time, the program grew a little...

**Q:I found an error, what should I do?**

**A:** Write about it right here on the forum in the thread[Discussion of the Quas application](https://vrcomm.ru/topic/101-quest-adb-scripts-quas/)Or directly from the program, use the WF options - Leave a review or send a file. I'll try to fix it for the next release.

**Q:The headset is in bootloader mode. I connect it to the PC with a cable, launch Quas, and it says the headset is not detected. The drivers are installed.**

**A:** Install more recent versions of drivers, the best one so far is 1.72.[You can download them in the Downloads section.](https://vrcomm.ru/files/file/5-%D0%B4%D1%80%D0%B0%D0%B9%D0%B2%D0%B5%D1%80%D1%8B-%D0%B4%D0%BB%D1%8F-oculus-quest/) this forum.

**Q:** When starting, the following messages appear: 'mode' is not recognized as an internal or external command, operable program or batch file and 'chcp' is not recognized as an internal or external command, operable program or batch file.

**A:** Most likely, you are missing some required elements of the PATH system variable, namely: C:\\Windows, C:\\Windows\\System32.
To resolve this error, you should add these missing parameters to the PATH variable.
Open a cmd console with administrator rights and run this command there:
```
setx PATH "%PATH%;%SystemRoot%;%SystemRoot%\System32"
```
Then restart your computer and check again.

**Q: I flashed my headset with your program, and now it won't boot. Is this due to manual flashing or is the program to blame?**

**A:**Neither. Unfortunately, this happens, and it doesn't matter whether you flash it officially over the air or manually. The program doesn't actually flash the firmware; it only uploads the firmware file to the headset using the standard Android mechanism: adb sideload update.zip. After the firmware file is sent to the device, the headset itself handles the actual firmware installation, having first double-checked the file for certificates and valid checksums. For this reason, it's also impossible to flash a modified or incompatible firmware file—the headset simply won't "approve" it and won't flash it. It also checks whether the file version matches the headset version.

You can also read this article:[What is the difference between flashing a headset over the air (OTA), manually, and through the Meta website?](https://vrcomm.ru/forums/topic/1115-%D0%B2-%D1%87%D0%B5%D0%BC-%D1%80%D0%B0%D0%B7%D0%BD%D0%B8%D1%86%D0%B0-%D0%BC%D0%B5%D0%B6%D0%B4%D1%83-%D0%BF%D1%80%D0%BE%D1%88%D0%B8%D0%B2%D0%BA%D0%BE%D0%B9-%D1%88%D0%BB%D0%B5%D0%BC%D0%B0-%D0%BF%D0%BE-%D0%B2%D0%BE%D0%B7%D0%B4%D1%83%D1%85%D1%83-ota-%D0%B2%D1%80%D1%83%D1%87%D0%BD%D1%83%D1%8E-%D0%B8-%D1%87%D0%B5%D1%80%D0%B5%D0%B7-%D0%B2%D0%B5%D0%B1-%D1%81%D0%B0%D0%B9%D1%82-meta)

**B: I launch the program and receive a lot of messages. "The system cannot write to the specified device."**

**A:** This is due to Cyrillic console fonts; not all of them support Cyrillic in UTF-8. Open the cmd console and right-click the console window icon in the upper left corner. Select "Default" and in the Fonts tab, set the font to Lucida Console or Consolas. Alternatively, use the English version of Quas, which doesn't have this issue.

----------------------
#### Contact me:
- ![itch.io - Quest ADB Scripts)](https://i.ibb.co/17kkCvR/itchio.png) [itch.io - Quest ADB Scripts](https://varset.itch.io/quest-adb-scripts)
- ![Discord (Quas Server)](https://i.ibb.co/xJ7H1NH/dl.png) [Discord (Quas Server)](https://discord.gg/GsBh3M5pU5)
- ![Telegram (Quas Group)](https://i.ibb.co/Y0xrjFD/tg.png) [Telegram (Quas Group)](https://t.me/QuestADBScripts)
- ![Telegram (Personal Account)](https://i.ibb.co/Y0xrjFD/tg.png) [Telegram (Personal Account)](https://t.me/Varsett)
- ![Github](https://i.ibb.co/YNcmzmv/gh.png) [Github](https://github.com/Varsett)
- ![FAQ](https://i.ibb.co/1zyzG5L/qa.png) [FAQ](https://rentry.co/quasfaq)
