param(
    [string]$WorkDir="",
    [string]$ToolsPath="",
    [ValidateSet("RU","EN","")]
    [string]$lang=""
)

# ==============================================================================
# LOCALIZATION (RU/EN)
# ==============================================================================
# Compile-time default UI language, used when the app is started without -lang.
# Set this to "RU" or "EN" before compiling with ps2exe to bake in the default.
$script:DefaultLang="EN"
$script:Lang=if($lang -eq "RU" -or $lang -eq "EN"){$lang}else{$script:DefaultLang}
# $script:Strings is populated further below (see LOCALIZATION STRING TABLE).
# T = translate: looks up a key in the current language, falls back to EN, falls back to the key itself.
function T{param([string]$k,[object[]]$fmt=$null)
    $s=$null
    if($script:Strings.ContainsKey($script:Lang) -and $script:Strings[$script:Lang].ContainsKey($k)){$s=$script:Strings[$script:Lang][$k]}
    elseif($script:Strings.ContainsKey("EN") -and $script:Strings["EN"].ContainsKey($k)){$s=$script:Strings["EN"][$k]}
    if($null -eq $s){return $k}
    if($fmt -and $fmt.Count -gt 0){return ($s -f $fmt)}
    return $s}
$script:Strings=@{
EN=@{
  "btn_f2"="F2 Rename"
  "btn_f3"="F3 Search"
  "btn_f4"="F4 Edit"
  "btn_f5"="F5 Copy"
  "btn_f6"="F6 Move"
  "btn_f7"="F7 MkDir"
  "btn_f8"="F8 Delete"
  "btn_f9"="F9 Data"
  "btn_f10"="F10 Obb"
  "btn_help"="?"
  "btn_stop"="STOP"
  "st_cancelling"="Cancelling..."
  "st_pushing"="PUSHING"
  "st_pulling"="PULLING"
  "st_done_push"="DONE push"
  "st_done_pull"="DONE pull"
  "st_cancelled_op"="Cancelled: {0}"
  "btn_ok"="OK"
  "btn_cancel"="Cancel"
  "dlg_install_apk_title"="Install APK"
  "dlg_install_apk_body"="Install APK on device?"
  "lbl_file"="File"
  "lbl_package"="Package"
  "lbl_obb"="OBB"
  "msg_aapt2_not_found"="(aapt2 not found)"
  "msg_obb_found"="found, will be copied"
  "st_installing"="INSTALLING"
  "st_installed"="INSTALLED"
  "st_install_failed"="INSTALL FAILED"
  "st_obb"="OBB"
  "st_done_apk_obb"="DONE: APK+OBB ({0} files)"
  "msg_7z_not_found"="7z.exe not found"
  "st_extracting_xapk"="Extracting XAPK"
  "msg_xapk_no_apk"="XAPK: no APK files found inside"
  "dlg_install_xapk_title"="Install XAPK"
  "dlg_install_xapk_body"="Install XAPK on device?"
  "lbl_type"="Type"
  "msg_split_apks"="Split APKs ({0} parts)"
  "msg_files_will_be_copied"="{0} file(s) will be copied"
  "st_installing_xapk_split"="Installing XAPK (split)"
  "st_installing_xapk"="Installing XAPK"
  "st_installed_xapk"="INSTALLED XAPK"
  "st_obb_copied"="OBB copied: {0} file(s)"
  "st_xapk_install_failed"="XAPK INSTALL FAILED"
  "msg_7z_not_found_apks"="7z.exe not found - cannot install APKS"
  "st_extracting_apks"="Extracting APKS"
  "msg_apks_no_apk"="APKS: no APK files found inside"
  "dlg_install_apks_title"="Install APKS"
  "dlg_install_apks_body"="Install split APKs on device?"
  "lbl_splits"="Splits"
  "msg_apk_files_count"="{0} APK file(s)"
  "st_installing_apks"="Installing APKS"
  "st_installed_apks"="INSTALLED APKS"
  "st_apks_install_failed"="APKS INSTALL FAILED"
  "dlg_not_text_file"="Not a text file"
  "dlg_open_in_editor_anyway"="Open in editor anyway?"
  "dlg_open_anyway"="Open anyway?"
  "st_pulling_file"="Pulling"
  "st_pull_failed"="PULL FAILED"
  "st_ready"="READY"
  "col_name"="Name"
  "col_size"="Size"
  "col_date"="Date"
  "col_path"="Path"
  "dlg_search_title"="Search"
  "dlg_search_prompt"="Search (wildcard * supported):"
  "st_searching_for"="Searching '{0}'"
  "st_found_items"="Found {0} item(s)"
  "st_found_items_done"="Found {0} item(s) -- double-click to navigate"
  "dlg_rename_title"="Rename"
  "dlg_new_name"="New name:"
  "log_renamed"="Renamed: {0} -> {1}"
  "dlg_confirm_copy"="Confirm Copy"
  "dlg_copy_items_q"="Copy following item(s)?"
  "log_copy_done"="Copy done"
  "dlg_move_rename_title"="Move/Rename"
  "dlg_new_folder_title"="New Folder"
  "dlg_folder_name"="Folder name:"
  "dlg_new_folder_default"="New_Folder"
  "log_created"="Created: {0}"
  "dlg_confirm_delete"="Confirm Delete"
  "dlg_delete_items_q"="DELETE following item(s)?"
  "log_deleted"="Deleted: {0}"
  "st_creating_dir"="Creating dir"
  "log_extracted_to_android"="Extracted to Android: {0}"
  "hlp_title_suffix"="Help"
  "btn_close"="Close"
  "hlp_subtitle"="Dual-panel file manager for Meta Quest / Android"
  "hlp_credits1"="The script was written by Varset using Claude,Chat GPT, "
  "hlp_credits2"="Github Copilot, Gemini Dev and a shitload of swearing"
  "hlp_h_navigation"="NAVIGATION"
  "hlp_nav_tab"="Switch active panel"
  "hlp_nav_enter"="Open folder / Run / Enter archive"
  "hlp_nav_space"="Toggle mark (yellow)"
  "hlp_nav_star"="Mark ALL / Unmark ALL"
  "hlp_nav_altx"="Exit"
  "hlp_nav_f9"="Jump to Android/data"
  "hlp_nav_f10"="Jump to Android/obb"
  "hlp_nav_f12"="Diagnostics / logging"
  "hlp_h_fileops"="FILE OPERATIONS"
  "hlp_fo_f2"="Rename"
  "hlp_fo_f3"="Search  (* wildcard)"
  "hlp_fo_f4"="Open in built-in editor"
  "hlp_fo_f5"="Copy to opposite panel"
  "hlp_fo_f6"="Move / Rename"
  "hlp_fo_f7"="Create new folder"
  "hlp_fo_f8"="Delete selected; in Application Manager: Uninstall"
  "hlp_fo_stop"="Cancel the current operation (copy/pull/extract/install)"
  "hlp_h_editor"="BUILT-IN EDITOR"
  "hlp_ed_save"="Save"
  "hlp_ed_esc"="Close (asks if unsaved)"
  "hlp_ed_wrapbtn"="Wrap button"
  "hlp_ed_wrap"="Toggle word wrap"
  "hlp_ed_syntaxbtn"="Syntax button"
  "hlp_ed_syntax"="Syntax highlight on/off"
  "hlp_ed_star_note"="* in title = unsaved changes"
  "hlp_ed_search_note"="Search: highlight matches (3+ chars)"
  "hlp_ed_prevnext"="Prev/Next search results"
  "hlp_ed_rmb"="RMB: Copy / Paste"
  "hlp_ed_syntax_auto"="Syntax highlight (auto):"
  "hlp_h_ctxmenu"="CONTEXT MENU  (Right Click)"
  "ctx_run"="Run"
  "hlp_ctx_run"="Execute file (PC only)"
  "ctx_edit_builtin"="Edit (built-in)"
  "hlp_ctx_edit_builtin"="Open in editor (PC)"
  "ctx_edit_pullpush"="Edit (pull-edit-push)"
  "hlp_ctx_edit_pullpush"="Pull, edit, push back (ADB)"
  "ctx_open_default"="Open with default"
  "hlp_ctx_open_default"="Open with system app"
  "ctx_install_apk"="Install APK/XAPK/APKS"
  "hlp_ctx_install_apk"="Install APK + auto OBB"
  "ctx_copy"="Copy (mark + clipboard)"
  "hlp_ctx_copy"="Mark + system clipboard"
  "ctx_paste"="Paste"
  "hlp_ctx_paste"="PC<->ADB, PC->PC, ADB->ADB"
  "ctx_unpack"="Unpack archive"
  "hlp_ctx_unpack"="Extract to PC or Android"
  "ctx_pack"="Pack selected"
  "hlp_ctx_pack"="Pack marked to .7z"
  "hlp_h_archive"="ARCHIVE SUPPORT  (requires 7z.exe)"
  "hlp_ar_browse"="Browse archive as folder"
  "hlp_ar_f4key"="F4 on file"
  "hlp_ar_f4"="Open text file from archive; Save writes back"
  "hlp_ar_f5files"="F5 (files)"
  "hlp_ar_f5files_v"="Extract files flat (no subfolders)"
  "hlp_ar_f5folder"="F5 (folder)"
  "hlp_ar_f5folder_v"="Extract folder with structure"
  "hlp_ar_starf5"="* then F5"
  "hlp_ar_starf5_v"="Mark all + extract everything"
  "hlp_ar_closearch"="[Close Archive]"
  "hlp_ar_closearch_v"="Exit / go up inside archive"
  "hlp_ar_rmb_unpack"="RMB Unpack: extract ALL, choose destination"
  "hlp_ar_rmb_pack"="RMB Pack: pack marked items to .7z"
  "hlp_ar_formats"="Formats:"
  "hlp_h_multipart"="MULTIPART ARCHIVES"
  "hlp_mp_7z"="7-Zip multipart"
  "hlp_mp_rar"="WinRAR multipart"
  "hlp_mp_zip"="ZIP split"
  "hlp_mp_generic"="Generic split"
  "hlp_mp_note1"="Open or RMB ANY part ->"
  "hlp_mp_note2"="  always starts from part 1"
  "hlp_h_appmgr_list"="APPLICATION MANAGER - LIST MANAGEMENT"
  "hlp_am_category_k"="Category"
  "hlp_am_category_v"="Select Apps / All / System / Third-Party / Enabled / Disabled / Filtered / Removed / Update System"
  "hlp_am_ctrlf3"="Create or change a filter for the current category"
  "hlp_am_filtered_k"="Filtered"
  "hlp_am_filtered_v"="Show the filtered application list"
  "hlp_am_filtermode_k"="Filter mode"
  "hlp_am_filtermode_v"="[ALL] requires every phrase; [ANY] requires at least one phrase"
  "hlp_am_a"="Toggle application-name display; uses device aapt-arm-pie2 when available"
  "hlp_am_r"="Reset category/filter/name view and return to Android filesystem"
  "hlp_am_space"="Mark/unmark application"
  "hlp_am_ctrla"="Select all applications in the Android application panel"
  "hlp_am_note1"="When A is enabled, names are cached and filtering can match both AppName and package name."
  "hlp_am_note2"="If aapt-arm-pie2 is unavailable, Commander falls back to PC aapt2."
  "hlp_h_appmgr_ops"="APPLICATION MANAGER - APPLICATION OPERATIONS"
  "hlp_op_uninstall_k"="Uninstall application"
  "hlp_op_uninstall_v"="Remove the application; Commander verifies that it is no longer installed"
  "hlp_op_softuninstall_k"="Soft uninstall"
  "hlp_op_softuninstall_v"="Uninstall while keeping application data/cache when Android supports it"
  "hlp_op_clear_k"="Clear cache and data"
  "hlp_op_clear_v"="Clear application data and cache"
  "hlp_op_disable_k"="Disable application"
  "hlp_op_disable_v"="Disable application for User 0 (confirmation required)"
  "hlp_op_enable_k"="Enable application"
  "hlp_op_enable_v"="Enable application"
  "hlp_op_launch_k"="Launch application"
  "hlp_op_launch_v"="Start application (confirmation required)"
  "hlp_op_softstop_k"="Soft stop"
  "hlp_op_softstop_v"="Stop with adb shell am kill (confirmation required)"
  "hlp_op_forcestop_k"="Force stop"
  "hlp_op_forcestop_v"="Stop with adb shell am force-stop (confirmation required)"
  "hlp_op_restart_k"="Restart application"
  "hlp_op_restart_v"="Force-stop then launch (confirmation required)"
  "hlp_op_status_k"="View application status"
  "hlp_op_status_v"="Show AppName, package, enabled/stopped state, version, UID and User 0 data status"
  "hlp_op_running_k"="View running applications"
  "hlp_op_running_v"="Show detected running application packages"
  "hlp_op_save_k"="Save selected applications"
  "hlp_op_save_v"="Save selected package names to a text file"
  "hlp_op_extract_k"="Extract APK/OBB"
  "hlp_op_extract_v"="Extract selected APKs and optionally OBB files to a chosen PC folder"
  "hlp_op_fullpath_k"="View Full path"
  "hlp_op_fullpath_v"="Log pm list packages -f output for selected applications"
  "hlp_op_restore_k"="Restore"
  "hlp_op_restore_v"="Removed category: restore package with pm install-existing"
  "hlp_op_removeupd_k"="Remove Update"
  "hlp_op_removeupd_v"="Update System category: remove User 0 update and restore built-in system version"
  "hlp_op_note1"="All destructive/launch/stop/restart operations ask for confirmation."
  "hlp_op_note2"="Restore and Remove Update are available only in their applicable categories."
  "hlp_h_tools"="TOOLS SETUP"
  "hlp_tools_place"="Place in script folder or use -ToolsPath:"
  "hlp_tools_toolspath"="Folder with adb/7z tools"
  "hlp_tools_workdir"="Temp folder for archives"
  "hlp_tools_lang"="Interface language: RU or EN"
  "hlp_tools_example"="Example launch:"
  "hlp_h_media"="MEDIA PREVIEW  (Android)"
  "hlp_media_1"="DblClick video/photo/audio on Android panel"
  "hlp_media_2"="-> pulled to %TEMP%, opened with system app"
  "hlp_media_3"="Files > 500 MB require confirmation"
  "hlp_h_colors"="FILE COLORS"
  "hlp_col_exec"="Executables"
  "hlp_col_text"="Text files"
  "hlp_col_media"="Media files"
  "hlp_col_apk"="APK packages"
  "hlp_col_arch"="Archives"
  "hlp_col_dirs"="Directories"
  "hlp_col_marked"="Marked items"
  "hlp_col_other"="Other files"
  "hlp_h_docs"="DOCUMENTATION & SOURCE"
  "st_reading_completed"="Reading completed ({0}/{1})"
  "st_connected"="CONNECTED"
  "st_adb_not_found"="adb.exe not found - place it next to the script"
  "st_disconnected"="DISCONNECTED - Check USB"
  "st_adb_error"="ADB error"
  "ctx_back_to_browser"="Back to Android file browser"
  "ctx_soft_uninstall"="Soft uninstall (keep data and cache)"
  "ctx_soft_stop"="Soft stop (am kill)"
  "ctx_force_stop"="Force stop (am force-stop)"
  "ctx_save_selected"="Save selected applications to file"
  "ctx_restore_app"="Restore application"
  "dlg_extract_title"="Extract"
  "dlg_pc_path"="PC path:"
  "dlg_select_extract_folder"="Select extraction folder"
  "dlg_unpack_to_pc"="Unpack to PC (path above)"
  "dlg_android_colon"="Android:"
  "dlg_unpack_to_android"="Unpack to Android (path above)"
  "dlg_confirm_uninstall"="Confirm Uninstall"
  "dlg_uninstall_q"="Uninstall the following application(s)?"
  "dlg_confirm_soft_uninstall"="Confirm Soft Uninstall"
  "dlg_soft_uninstall_q"="Uninstall the following application(s) while keeping their data and cache?"
  "dlg_confirm_clear_data"="Confirm Clear Data"
  "dlg_clear_data_q"="Clear cache and data for the following application(s)?"
  "dlg_confirm_disable"="Confirm Disable"
  "dlg_disable_q"="Disable the following application(s)?"
  "dlg_confirm_launch"="Confirm Launch"
  "dlg_launch_q"="Launch the following application(s)?"
  "dlg_confirm_stop"="Confirm Stop"
  "dlg_soft_stop_q"="Soft-stop the following application(s)?"
  "dlg_confirm_force_stop"="Confirm Force Stop"
  "dlg_force_stop_q"="Force-stop the following application(s)?"
  "dlg_confirm_restart"="Confirm Restart"
  "dlg_restart_q"="Restart the following application(s)?"
  "dlg_confirm_restore"="Confirm Restore"
  "dlg_restore_q"="Restore the following removed/uninstalled application(s)?"
  "dlg_confirm_remove_update"="Confirm Remove Update"
  "dlg_remove_update_q"="Remove the update for the following system application(s) and restore the built-in system version?"
  "dlg_app_status"="Application Status"
  "dlg_running_apps"="Running Applications"
  "msg_no_running_apps"="No running application packages were detected."
  "msg_currently_running"="Currently detected running application packages:"
  "dlg_save_selected_apps"="Save Selected Applications"
  "dlg_diag_logging"="Diagnostics / Logging"
  "lbl_output"="Output"
  "log_out_off"="Off"
  "log_out_window"="Window"
  "log_out_file"="File"
  "log_out_both"="Window + File"
  "lbl_log_level"="Log level"
  "log_lvl_errors"="Errors"
  "log_lvl_errors_important"="Errors + Important"
  "log_lvl_detailed"="Detailed"
  "log_lvl_debug"="Debug"
  "hlp_f12_hint"="F12 - show/hide this panel"
  "st_copying_on_device"="Copying on device"
  "log_copied_on_device"="Copied on device"
  "log_skipped_same_path"="Skipped (same path)"
  "log_copied"="Copied"
  "log_copy_failed"="Copy failed"
  "log_paste_done"="Paste done"
  "log_paste_cancelled"="Paste cancelled"
  "st_pulling_archive"="Pulling archive from Android"
  "log_pull_archive_failed"="Failed to pull archive from Android"
  "log_multipart_first_part"="Multipart: using first part: {0}"
  "st_extracting"="Extracting"
  "st_extract_error"="Extract error"
  "log_extracted_to"="Extracted to"
  "st_packing"="Packing"
  "log_packed"="Packed"
  "msg_no_items_for_pack"="No items selected for packing"
  "msg_pack_pc_only"="Pack only supported on PC panel"
  "dlg_pack_archive"="Pack Archive"
  "dlg_archive_name"="Archive name:"
  "msg_cannot_open_dir"="Cannot open directory"
  "ed_title_prefix"="Edit"
  "ed_search_found"="{0}/{1} found"
  "ed_search_notfound"="not found"
  "ed_original_encoding"="Original encoding"
  "ed_error_reading_file"="Error reading file"
  "ed_msg_archive_update_failed"="File saved to temporary folder, but failed update archive.
Check log."
  "ed_archive_error_title"="Archive error"
  "ed_saved_to_android"="Saved to Android"
  "ed_saved_to_archive"="Saved to archive"
  "ed_saved_and_converted"="Saved and converted to"
  "ed_error_saving"="Error file saving"
  "ed_error_title"="Error"
  "ed_unsaved_body"="Unsaved changes. Save now?"
  "ed_unsaved_title"="Unsaved"
  "ed_failed_transfer_android"="Failed to transfer saved file back to Android"
  "st_reading_app_names"="Wait... reading application names ({0}/{1})"
  "msg_aapt_arm_not_found"="aapt-arm-pie2 not found. Application names will be read using aapt2.exe on the PC and this may take longer."
  "msg_no_aapt_available"="Neither aapt-arm-pie2 nor aapt2.exe is available for reading application names."
  "st_cancelling_appnames"="Cancelling AppNames reading..."
  "st_reading_app_names_cancelled"="Wait... reading application names cancelled ({0}/{1})"
  "dlg_appnames_title"="AppNames"
  "msg_appnames_confirm_body"="Creating the application name list may take some time because Commander has to read the application names from the APK files.

Continue?"
  "msg_appname_scan_failed"="Application name scan failed"
  "msg_appname_scan_cancelled"="Application name scan cancelled"
  "cat_select_apps"="Select Apps"
  "cat_all"="All"
  "cat_system"="System"
  "cat_third_party"="Third-Party"
  "cat_enabled"="Enabled"
  "cat_disabled"="Disabled"
  "cat_filtered"="Filtered"
  "cat_removed"="Removed"
  "cat_update_system"="Update System"
  "dlg_filter_apps_title"="Filter Applications"
  "dlg_filter_apps_lbl"="Enter package name fragments separated by commas:"
  "dlg_filter_apps_all"="All phrases must occur in the same package name"
  "dlg_filter_apps_any"="Any phrase may occur in the package name"
  "dlg_filter_apps_hint"="Example: virt, ando, desktop  |  Leave empty to clear the filter"
  "msg_select_category_first"="Select an application category first"
  "log_app_filter_cleared"="Application filter cleared"
  "log_app_filter_set"="Application filter: {0} [{1}]"
  "filter_mode_all"="ALL"
  "filter_mode_any"="ANY"
  "lbl_filtered_colon"="Filtered:"
  "st_scanning_system_updates"="Wait... scanning system application updates"
  "st_scanning_system_updates_progress"="Wait... scanning system application updates ({0}/{1})"
  "msg_multipart_link_failed"="Could not link multipart volume"
}
RU=@{
  "btn_f2"="F2 Переим."
  "btn_f3"="F3 Поиск"
  "btn_f4"="F4 Правка"
  "btn_f5"="F5 Копир."
  "btn_f6"="F6 Перенос"
  "btn_f7"="F7 НовПап"
  "btn_f8"="F8 Удалить"
  "btn_f9"="F9 Data"
  "btn_f10"="F10 Obb"
  "btn_help"="?"
  "btn_stop"="СТОП"
  "st_cancelling"="Отмена..."
  "st_pushing"="ОТПРАВКА"
  "st_pulling"="ЗАГРУЗКА"
  "st_done_push"="Готово: отправлено"
  "st_done_pull"="Готово: получено"
  "st_cancelled_op"="Отменено: {0}"
  "btn_ok"="OK"
  "btn_cancel"="Отмена"
  "dlg_install_apk_title"="Установка APK"
  "dlg_install_apk_body"="Установить APK на устройство?"
  "lbl_file"="Файл"
  "lbl_package"="Пакет"
  "lbl_obb"="OBB"
  "msg_aapt2_not_found"="(aapt2 не найден)"
  "msg_obb_found"="найден, будет скопирован"
  "st_installing"="УСТАНОВКА"
  "st_installed"="УСТАНОВЛЕНО"
  "st_install_failed"="ОШИБКА УСТАНОВКИ"
  "st_obb"="OBB"
  "st_done_apk_obb"="Готово: APK+OBB ({0} файл(ов))"
  "msg_7z_not_found"="7z.exe не найден"
  "st_extracting_xapk"="Распаковка XAPK"
  "msg_xapk_no_apk"="XAPK: внутри не найдено файлов APK"
  "dlg_install_xapk_title"="Установка XAPK"
  "dlg_install_xapk_body"="Установить XAPK на устройство?"
  "lbl_type"="Тип"
  "msg_split_apks"="Раздельные APK ({0} частей)"
  "msg_files_will_be_copied"="будет скопировано файлов: {0}"
  "st_installing_xapk_split"="Установка XAPK (раздельный)"
  "st_installing_xapk"="Установка XAPK"
  "st_installed_xapk"="XAPK УСТАНОВЛЕН"
  "st_obb_copied"="OBB скопировано: {0} файл(ов)"
  "st_xapk_install_failed"="ОШИБКА УСТАНОВКИ XAPK"
  "msg_7z_not_found_apks"="7z.exe не найден - установка APKS невозможна"
  "st_extracting_apks"="Распаковка APKS"
  "msg_apks_no_apk"="APKS: внутри не найдено файлов APK"
  "dlg_install_apks_title"="Установка APKS"
  "dlg_install_apks_body"="Установить раздельные APK на устройство?"
  "lbl_splits"="Части"
  "msg_apk_files_count"="файлов APK: {0}"
  "st_installing_apks"="Установка APKS"
  "st_installed_apks"="APKS УСТАНОВЛЕН"
  "st_apks_install_failed"="ОШИБКА УСТАНОВКИ APKS"
  "dlg_not_text_file"="Не текстовый файл"
  "dlg_open_in_editor_anyway"="Всё равно открыть в редакторе?"
  "dlg_open_anyway"="Всё равно открыть?"
  "st_pulling_file"="Загрузка"
  "st_pull_failed"="ОШИБКА ЗАГРУЗКИ"
  "st_ready"="ГОТОВО"
  "col_name"="Имя"
  "col_size"="Размер"
  "col_date"="Дата"
  "col_path"="Путь"
  "dlg_search_title"="Поиск"
  "dlg_search_prompt"="Поиск (поддерживается маска *):"
  "st_searching_for"="Поиск '{0}'"
  "st_found_items"="Найдено объектов: {0}"
  "st_found_items_done"="Найдено объектов: {0} -- двойной клик для перехода"
  "dlg_rename_title"="Переименовать"
  "dlg_new_name"="Новое имя:"
  "log_renamed"="Переименовано: {0} -> {1}"
  "dlg_confirm_copy"="Подтверждение копирования"
  "dlg_copy_items_q"="Скопировать следующие объекты?"
  "log_copy_done"="Копирование завершено"
  "dlg_move_rename_title"="Перемещение/Переименование"
  "dlg_new_folder_title"="Новая папка"
  "dlg_folder_name"="Имя папки:"
  "dlg_new_folder_default"="Новая_папка"
  "log_created"="Создано: {0}"
  "dlg_confirm_delete"="Подтверждение удаления"
  "dlg_delete_items_q"="УДАЛИТЬ следующие объекты?"
  "log_deleted"="Удалено: {0}"
  "st_creating_dir"="Создание папки"
  "log_extracted_to_android"="Распаковано на Android: {0}"
  "hlp_title_suffix"="Справка"
  "btn_close"="Закрыть"
  "hlp_subtitle"="Двухпанельный файловый менеджер для Meta Quest / Android"
  "hlp_credits1"="Скрипт написан Varset с использованием Claude, Chat GPT, "
  "hlp_credits2"="Github Copilot, Gemini Dev и огромного количества ругани"
  "hlp_h_navigation"="НАВИГАЦИЯ"
  "hlp_nav_tab"="Переключить активную панель"
  "hlp_nav_enter"="Открыть папку / Запустить / Войти в архив"
  "hlp_nav_space"="Отметить/снять отметку (жёлтым)"
  "hlp_nav_star"="Отметить ВСЁ / Снять все отметки"
  "hlp_nav_altx"="Выход"
  "hlp_nav_f9"="Перейти в Android/data"
  "hlp_nav_f10"="Перейти в Android/obb"
  "hlp_nav_f12"="Диагностика / журнал"
  "hlp_h_fileops"="ФАЙЛОВЫЕ ОПЕРАЦИИ"
  "hlp_fo_f2"="Переименовать"
  "hlp_fo_f3"="Поиск  (маска *)"
  "hlp_fo_f4"="Открыть во встроенном редакторе"
  "hlp_fo_f5"="Копировать в противоположную панель"
  "hlp_fo_f6"="Переместить / Переименовать"
  "hlp_fo_f7"="Создать новую папку"
  "hlp_fo_f8"="Удалить выбранное; в Диспетчере приложений: Удалить приложение"
  "hlp_fo_stop"="Отменить текущую операцию (копирование/загрузка/распаковка/установка)"
  "hlp_h_editor"="ВСТРОЕННЫЙ РЕДАКТОР"
  "hlp_ed_save"="Сохранить"
  "hlp_ed_esc"="Закрыть (спросит, если есть несохранённые изменения)"
  "hlp_ed_wrapbtn"="Кнопка `"Wrap`""
  "hlp_ed_wrap"="Переключить перенос строк"
  "hlp_ed_syntaxbtn"="Кнопка `"Syntax`""
  "hlp_ed_syntax"="Подсветка синтаксиса вкл/выкл"
  "hlp_ed_star_note"="* в заголовке = есть несохранённые изменения"
  "hlp_ed_search_note"="Поиск: подсветка совпадений (от 3 символов)"
  "hlp_ed_prevnext"="Пред./След. результат поиска"
  "hlp_ed_rmb"="ПКМ: Копировать / Вставить"
  "hlp_ed_syntax_auto"="Автоподсветка синтаксиса:"
  "hlp_h_ctxmenu"="КОНТЕКСТНОЕ МЕНЮ  (ПКМ)"
  "ctx_run"="Запустить"
  "hlp_ctx_run"="Запустить файл (только PC)"
  "ctx_edit_builtin"="Правка (встроенным редактором)"
  "hlp_ctx_edit_builtin"="Открыть в редакторе (PC)"
  "ctx_edit_pullpush"="Правка (загрузить-править-отправить)"
  "hlp_ctx_edit_pullpush"="Загрузить, изменить, отправить обратно (ADB)"
  "ctx_open_default"="Открыть по умолчанию"
  "hlp_ctx_open_default"="Открыть системным приложением"
  "ctx_install_apk"="Установить APK/XAPK/APKS"
  "hlp_ctx_install_apk"="Установить APK + автоматически OBB"
  "ctx_copy"="Копировать (отметка + буфер обмена)"
  "hlp_ctx_copy"="Отметка + системный буфер обмена"
  "ctx_paste"="Вставить"
  "hlp_ctx_paste"="PC<->ADB, PC->PC, ADB->ADB"
  "ctx_unpack"="Распаковать архив"
  "hlp_ctx_unpack"="Распаковать на PC или Android"
  "ctx_pack"="Упаковать выбранное"
  "hlp_ctx_pack"="Упаковать отмеченное в .7z"
  "hlp_h_archive"="ПОДДЕРЖКА АРХИВОВ  (требуется 7z.exe)"
  "hlp_ar_browse"="Просмотр архива как папки"
  "hlp_ar_f4key"="F4 на файле"
  "hlp_ar_f4"="Открыть текстовый файл из архива; Сохранение запишет обратно"
  "hlp_ar_f5files"="F5 (файлы)"
  "hlp_ar_f5files_v"="Извлечь файлы без структуры папок"
  "hlp_ar_f5folder"="F5 (папка)"
  "hlp_ar_f5folder_v"="Извлечь папку с сохранением структуры"
  "hlp_ar_starf5"="* затем F5"
  "hlp_ar_starf5_v"="Отметить всё + извлечь всё"
  "hlp_ar_closearch"="[Закрыть архив]"
  "hlp_ar_closearch_v"="Выйти / подняться внутри архива"
  "hlp_ar_rmb_unpack"="ПКМ Распаковать: извлечь ВСЁ, выбрать назначение"
  "hlp_ar_rmb_pack"="ПКМ Упаковать: упаковать отмеченное в .7z"
  "hlp_ar_formats"="Форматы:"
  "hlp_h_multipart"="МНОГОТОМНЫЕ АРХИВЫ"
  "hlp_mp_7z"="Многотомный 7-Zip"
  "hlp_mp_rar"="Многотомный WinRAR"
  "hlp_mp_zip"="Разделённый ZIP"
  "hlp_mp_generic"="Обычный разделённый архив"
  "hlp_mp_note1"="Открытие или ПКМ на ЛЮБОЙ части ->"
  "hlp_mp_note2"="  всегда начинает с части 1"
  "hlp_h_appmgr_list"="ДИСПЕТЧЕР ПРИЛОЖЕНИЙ - УПРАВЛЕНИЕ СПИСКОМ"
  "hlp_am_category_k"="Категория"
  "hlp_am_category_v"="Select Apps / All / System / Third-Party / Enabled / Disabled / Filtered / Removed / Update System"
  "hlp_am_ctrlf3"="Создать или изменить фильтр для текущей категории"
  "hlp_am_filtered_k"="Filtered"
  "hlp_am_filtered_v"="Показать отфильтрованный список приложений"
  "hlp_am_filtermode_k"="Режим фильтра"
  "hlp_am_filtermode_v"="[ALL] требует все фразы; [ANY] требует хотя бы одну фразу"
  "hlp_am_a"="Переключить отображение имён приложений; использует aapt-arm-pie2 на устройстве, если доступен"
  "hlp_am_r"="Сбросить категорию/фильтр/имена и вернуться к файловой системе Android"
  "hlp_am_space"="Отметить/снять отметку с приложения"
  "hlp_am_ctrla"="Выбрать все приложения в панели Android"
  "hlp_am_note1"="Когда A включено, имена кэшируются, и фильтрация может искать как по имени приложения, так и по имени пакета."
  "hlp_am_note2"="Если aapt-arm-pie2 недоступен, Commander использует aapt2 на PC."
  "hlp_h_appmgr_ops"="ДИСПЕТЧЕР ПРИЛОЖЕНИЙ - ОПЕРАЦИИ С ПРИЛОЖЕНИЯМИ"
  "hlp_op_uninstall_k"="Удалить приложение"
  "hlp_op_uninstall_v"="Удаляет приложение; Commander проверяет, что оно действительно удалено"
  "hlp_op_softuninstall_k"="Мягкое удаление"
  "hlp_op_softuninstall_v"="Удаление с сохранением данных/кэша приложения, если это поддерживается Android"
  "hlp_op_clear_k"="Очистить кэш и данные"
  "hlp_op_clear_v"="Очищает данные и кэш приложения"
  "hlp_op_disable_k"="Отключить приложение"
  "hlp_op_disable_v"="Отключает приложение для User 0 (требуется подтверждение)"
  "hlp_op_enable_k"="Включить приложение"
  "hlp_op_enable_v"="Включает приложение"
  "hlp_op_launch_k"="Запустить приложение"
  "hlp_op_launch_v"="Запускает приложение (требуется подтверждение)"
  "hlp_op_softstop_k"="Мягкая остановка"
  "hlp_op_softstop_v"="Остановка через adb shell am kill (требуется подтверждение)"
  "hlp_op_forcestop_k"="Принудительная остановка"
  "hlp_op_forcestop_v"="Остановка через adb shell am force-stop (требуется подтверждение)"
  "hlp_op_restart_k"="Перезапустить приложение"
  "hlp_op_restart_v"="Принудительная остановка и повторный запуск (требуется подтверждение)"
  "hlp_op_status_k"="Показать статус приложения"
  "hlp_op_status_v"="Показывает имя, пакет, состояние вкл/выкл, версию, UID и статус данных User 0"
  "hlp_op_running_k"="Показать запущенные приложения"
  "hlp_op_running_v"="Показывает обнаруженные запущенные пакеты приложений"
  "hlp_op_save_k"="Сохранить выбранные приложения"
  "hlp_op_save_v"="Сохраняет имена выбранных пакетов в текстовый файл"
  "hlp_op_extract_k"="Извлечь APK/OBB"
  "hlp_op_extract_v"="Извлекает выбранные APK и, при наличии, файлы OBB в выбранную папку PC"
  "hlp_op_fullpath_k"="Показать полный путь"
  "hlp_op_fullpath_v"="Выводит в журнал результат pm list packages -f для выбранных приложений"
  "hlp_op_restore_k"="Восстановить"
  "hlp_op_restore_v"="Категория Removed: восстанавливает пакет через pm install-existing"
  "hlp_op_removeupd_k"="Удалить обновление"
  "hlp_op_removeupd_v"="Категория Update System: удаляет обновление User 0 и восстанавливает встроенную системную версию"
  "hlp_op_note1"="Все разрушительные операции (запуск/остановка/перезапуск) запрашивают подтверждение."
  "hlp_op_note2"="Restore и Remove Update доступны только в соответствующих категориях."
  "hlp_h_tools"="НАСТРОЙКА ИНСТРУМЕНТОВ"
  "hlp_tools_place"="Разместите в папке скрипта или используйте -ToolsPath:"
  "hlp_tools_toolspath"="Папка с инструментами adb/7z"
  "hlp_tools_workdir"="Временная папка для архивов"
  "hlp_tools_lang"="Язык интерфейса: RU или EN"
  "hlp_tools_example"="Пример запуска:"
  "hlp_h_media"="ПРОСМОТР МЕДИА  (Android)"
  "hlp_media_1"="Двойной клик по видео/фото/аудио в панели Android"
  "hlp_media_2"="-> загружается в %TEMP%, открывается системным приложением"
  "hlp_media_3"="Файлы > 500 МБ требуют подтверждения"
  "hlp_h_colors"="ЦВЕТА ФАЙЛОВ"
  "hlp_col_exec"="Исполняемые файлы"
  "hlp_col_text"="Текстовые файлы"
  "hlp_col_media"="Медиафайлы"
  "hlp_col_apk"="Пакеты APK"
  "hlp_col_arch"="Архивы"
  "hlp_col_dirs"="Папки"
  "hlp_col_marked"="Отмеченные объекты"
  "hlp_col_other"="Прочие файлы"
  "hlp_h_docs"="ДОКУМЕНТАЦИЯ И ИСХОДНЫЙ КОД"
  "st_reading_completed"="Чтение завершено ({0}/{1})"
  "st_connected"="ПОДКЛЮЧЕНО"
  "st_adb_not_found"="adb.exe не найден - поместите его рядом со скриптом"
  "st_disconnected"="ОТКЛЮЧЕНО - проверьте USB"
  "st_adb_error"="Ошибка ADB"
  "ctx_back_to_browser"="Назад к файловому браузеру Android"
  "ctx_soft_uninstall"="Мягкое удаление (сохранить данные и кэш)"
  "ctx_soft_stop"="Мягкая остановка (am kill)"
  "ctx_force_stop"="Принудительная остановка (am force-stop)"
  "ctx_save_selected"="Сохранить выбранные приложения в файл"
  "ctx_restore_app"="Восстановить приложение"
  "dlg_extract_title"="Извлечь"
  "dlg_pc_path"="Путь PC:"
  "dlg_select_extract_folder"="Выберите папку для извлечения"
  "dlg_unpack_to_pc"="Распаковать на PC (путь выше)"
  "dlg_android_colon"="Android:"
  "dlg_unpack_to_android"="Распаковать на Android (путь выше)"
  "dlg_confirm_uninstall"="Подтверждение удаления"
  "dlg_uninstall_q"="Удалить следующие приложения?"
  "dlg_confirm_soft_uninstall"="Подтверждение мягкого удаления"
  "dlg_soft_uninstall_q"="Удалить следующие приложения с сохранением данных и кэша?"
  "dlg_confirm_clear_data"="Подтверждение очистки данных"
  "dlg_clear_data_q"="Очистить кэш и данные для следующих приложений?"
  "dlg_confirm_disable"="Подтверждение отключения"
  "dlg_disable_q"="Отключить следующие приложения?"
  "dlg_confirm_launch"="Подтверждение запуска"
  "dlg_launch_q"="Запустить следующие приложения?"
  "dlg_confirm_stop"="Подтверждение остановки"
  "dlg_soft_stop_q"="Мягко остановить следующие приложения?"
  "dlg_confirm_force_stop"="Подтверждение принудительной остановки"
  "dlg_force_stop_q"="Принудительно остановить следующие приложения?"
  "dlg_confirm_restart"="Подтверждение перезапуска"
  "dlg_restart_q"="Перезапустить следующие приложения?"
  "dlg_confirm_restore"="Подтверждение восстановления"
  "dlg_restore_q"="Восстановить следующие удалённые приложения?"
  "dlg_confirm_remove_update"="Подтверждение удаления обновления"
  "dlg_remove_update_q"="Удалить обновление для следующих системных приложений и восстановить встроенную версию?"
  "dlg_app_status"="Статус приложения"
  "dlg_running_apps"="Запущенные приложения"
  "msg_no_running_apps"="Запущенные пакеты приложений не обнаружены."
  "msg_currently_running"="Обнаруженные запущенные пакеты приложений:"
  "dlg_save_selected_apps"="Сохранить выбранные приложения"
  "dlg_diag_logging"="Диагностика / Журнал"
  "lbl_output"="Вывод"
  "log_out_off"="Выкл"
  "log_out_window"="Окно"
  "log_out_file"="Файл"
  "log_out_both"="Окно + Файл"
  "lbl_log_level"="Уровень журнала"
  "log_lvl_errors"="Ошибки"
  "log_lvl_errors_important"="Ошибки + Важное"
  "log_lvl_detailed"="Подробно"
  "log_lvl_debug"="Отладка"
  "hlp_f12_hint"="F12 - показать/скрыть эту панель"
  "st_copying_on_device"="Копирование на устройстве"
  "log_copied_on_device"="Скопировано на устройстве"
  "log_skipped_same_path"="Пропущено (тот же путь)"
  "log_copied"="Скопировано"
  "log_copy_failed"="Ошибка копирования"
  "log_paste_done"="Вставка завершена"
  "log_paste_cancelled"="Вставка отменена"
  "st_pulling_archive"="Загрузка архива с Android"
  "log_pull_archive_failed"="Не удалось загрузить архив с Android"
  "log_multipart_first_part"="Многотомный архив: используется первая часть: {0}"
  "st_extracting"="Распаковка"
  "st_extract_error"="Ошибка распаковки"
  "log_extracted_to"="Распаковано в"
  "st_packing"="Упаковка"
  "log_packed"="Упаковано"
  "msg_no_items_for_pack"="Не выбраны объекты для упаковки"
  "msg_pack_pc_only"="Упаковка доступна только на панели PC"
  "dlg_pack_archive"="Упаковать архив"
  "dlg_archive_name"="Имя архива:"
  "msg_cannot_open_dir"="Невозможно открыть папку"
  "ed_title_prefix"="Правка"
  "ed_search_found"="{0}/{1} найдено"
  "ed_search_notfound"="не найдено"
  "ed_original_encoding"="Исходная кодировка"
  "ed_error_reading_file"="Ошибка чтения файла"
  "ed_msg_archive_update_failed"="Файл сохранён во временную папку, но не удалось обновить архив.
Проверьте журнал."
  "ed_archive_error_title"="Ошибка архива"
  "ed_saved_to_android"="Сохранено на Android"
  "ed_saved_to_archive"="Сохранено в архив"
  "ed_saved_and_converted"="Сохранено и преобразовано в"
  "ed_error_saving"="Ошибка сохранения файла"
  "ed_error_title"="Ошибка"
  "ed_unsaved_body"="Есть несохранённые изменения. Сохранить сейчас?"
  "ed_unsaved_title"="Не сохранено"
  "ed_failed_transfer_android"="Не удалось передать сохранённый файл обратно на Android"
  "st_reading_app_names"="Подождите... чтение имён приложений ({0}/{1})"
  "msg_aapt_arm_not_found"="aapt-arm-pie2 не найден. Имена приложений будут прочитаны через aapt2.exe на PC, это может занять больше времени."
  "msg_no_aapt_available"="Ни aapt-arm-pie2, ни aapt2.exe недоступны для чтения имён приложений."
  "st_cancelling_appnames"="Отмена чтения имён приложений..."
  "st_reading_app_names_cancelled"="Подождите... чтение имён приложений отменено ({0}/{1})"
  "dlg_appnames_title"="Имена приложений"
  "msg_appnames_confirm_body"="Создание списка имён приложений может занять некоторое время, так как Commander должен прочитать имена приложений из файлов APK.

Продолжить?"
  "msg_appname_scan_failed"="Не удалось прочитать имена приложений"
  "msg_appname_scan_cancelled"="Чтение имён приложений отменено"
  "cat_select_apps"="Выбор приложений"
  "cat_all"="Все"
  "cat_system"="Системные"
  "cat_third_party"="Сторонние"
  "cat_enabled"="Включённые"
  "cat_disabled"="Отключённые"
  "cat_filtered"="Отфильтрованные"
  "cat_removed"="Удалённые"
  "cat_update_system"="Обновление системы"
  "dlg_filter_apps_title"="Фильтр приложений"
  "dlg_filter_apps_lbl"="Введите фрагменты имени пакета через запятую:"
  "dlg_filter_apps_all"="Все фразы должны встречаться в имени пакета"
  "dlg_filter_apps_any"="Достаточно любой фразы в имени пакета"
  "dlg_filter_apps_hint"="Пример: virt, ando, desktop  |  Оставьте пустым, чтобы очистить фильтр"
  "msg_select_category_first"="Сначала выберите категорию приложений"
  "log_app_filter_cleared"="Фильтр приложений очищен"
  "log_app_filter_set"="Фильтр приложений: {0} [{1}]"
  "filter_mode_all"="ВСЕ"
  "filter_mode_any"="ЛЮБАЯ"
  "lbl_filtered_colon"="Отфильтровано:"
  "st_scanning_system_updates"="Подождите... сканирование обновлений системных приложений"
  "st_scanning_system_updates_progress"="Подождите... сканирование обновлений системных приложений ({0}/{1})"
  "msg_multipart_link_failed"="Не удалось связать том многотомного архива"
}
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type -TypeDefinition @"
using System; using System.Runtime.InteropServices; using System.Windows.Forms;
public class WinApi { [DllImport("user32.dll")] public static extern int ShowScrollBar(IntPtr hWnd, int wBar, bool bShow); public const int SB_HORZ=0; }
public class NoHScrollListView : ListView {
    private const int WM_HSCROLL=0x114,WM_VSCROLL=0x115,WM_MOUSEWHEEL=0x20A,WM_SIZE=0x5,WM_PAINT=0xF;
    private void HideH(){try{WinApi.ShowScrollBar(Handle,WinApi.SB_HORZ,false);}catch{}}
    protected override void WndProc(ref Message m){base.WndProc(ref m);if(m.Msg==WM_HSCROLL||m.Msg==WM_VSCROLL||m.Msg==WM_MOUSEWHEEL||m.Msg==WM_SIZE||m.Msg==WM_PAINT)HideH();}
    protected override void OnHandleCreated(EventArgs e){base.OnHandleCreated(e);HideH();}
}
"@ -ReferencedAssemblies "System.Windows.Forms","System.Drawing","System"

try{[Console]::OutputEncoding=[System.Text.Encoding]::UTF8}catch{}
# Hide console window when running as compiled exe
# WinAPI helpers for window management
Add-Type -Name "FgWin32" -Namespace "" -MemberDefinition @"
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool BringWindowToTop(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern bool AllowSetForegroundWindow(int dwProcessId);
    [DllImport("user32.dll")] public static extern void SwitchToThisWindow(IntPtr hWnd, bool fAltTab);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
    [DllImport("kernel32.dll")] public static extern uint GetCurrentThreadId();
    [DllImport("user32.dll")] public static extern bool AttachThreadInput(uint idAttach, uint idAttachTo, bool fAttach);
    [DllImport("user32.dll")] public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    public static void ForceToForeground(IntPtr hWnd){
        // Double Alt press/release to unlock foreground lock and reset Alt state
        keybd_event(0x12, 0, 0, UIntPtr.Zero);
        keybd_event(0x12, 0, 0x0002, UIntPtr.Zero);
        keybd_event(0x12, 0, 0, UIntPtr.Zero);
        keybd_event(0x12, 0, 0x0002, UIntPtr.Zero);
        IntPtr hFg=GetForegroundWindow();
        uint fgThread=0; uint myThread=GetCurrentThreadId();
        if(hFg!=IntPtr.Zero){GetWindowThreadProcessId(hFg,out fgThread);}
        if(fgThread!=0&&fgThread!=myThread){AttachThreadInput(myThread,fgThread,true);}
        ShowWindow(hWnd,9);
        SetForegroundWindow(hWnd);
        BringWindowToTop(hWnd);
        if(fgThread!=0&&fgThread!=myThread){AttachThreadInput(myThread,fgThread,false);}
    }
"@ -ErrorAction SilentlyContinue
# Hide console window if running as compiled exe
try{
    $hwnd=[System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
    if($hwnd -ne [IntPtr]::Zero){[FgWin32]::ShowWindow($hwnd,0)|Out-Null}
}catch{}

# In ps2exe, PSScriptRoot may be null - use multiple fallbacks
$scriptDir=if($PSScriptRoot -and $PSScriptRoot -ne ""){
    $PSScriptRoot
}elseif($MyInvocation.MyCommand.Path -and $MyInvocation.MyCommand.Path -ne ""){
    Split-Path $MyInvocation.MyCommand.Path -Parent
}elseif([System.Reflection.Assembly]::GetExecutingAssembly().Location -and
        [System.Reflection.Assembly]::GetExecutingAssembly().Location -ne ""){
    Split-Path ([System.Reflection.Assembly]::GetExecutingAssembly().Location) -Parent
}else{
    [System.IO.Path]::GetDirectoryName([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
}
# WorkDir: temp folder for archive operations
$script:WorkDir=if($WorkDir -ne "" -and $null -ne $WorkDir){$WorkDir}elseif($env:TEMP -and $env:TEMP -ne ""){$env:TEMP}elseif($env:TMP -and $env:TMP -ne ""){$env:TMP}else{"C:\Temp"}
# Clean leftover temp dirs older than 1 hour
Get-ChildItem $script:WorkDir -Directory -ErrorAction SilentlyContinue|Where-Object{$_.Name -match '^[0-9a-f]{32}$' -and $_.LastWriteTime -lt (Get-Date).AddHours(-1)}|Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
if(-not(Test-Path $script:WorkDir)){New-Item -ItemType Directory -Path $script:WorkDir -Force|Out-Null}
# ToolsPath: folder with adb.exe, aapt2.exe, 7z.exe
$script:ToolsPath=if($ToolsPath -ne "" -and $null -ne $ToolsPath){$ToolsPath}elseif($scriptDir -and $scriptDir -ne ""){$scriptDir}else{""}
function Find-Tool{param([string]$n)
    # 1. ToolsPath param
    if($script:ToolsPath -and $script:ToolsPath -ne ""){
        $l=Join-Path $script:ToolsPath $n;if(Test-Path $l -ErrorAction SilentlyContinue){return $l}}
    # 2. Script / exe directory
    if($scriptDir -and $scriptDir -ne ""){
        $l2=Join-Path $scriptDir $n;if(Test-Path $l2 -ErrorAction SilentlyContinue){return $l2}}
    # 3. Exe location (ps2exe)
    try{
        $exeDir=Split-Path ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName) -Parent
        $l3=Join-Path $exeDir $n;if(Test-Path $l3 -ErrorAction SilentlyContinue){return $l3}
    }catch{}
    # 4. myfiles env variable
    $ev=[Environment]::GetEnvironmentVariable("myfiles","Process")
    if($ev){$p=if(Test-Path $ev -PathType Container -ErrorAction SilentlyContinue){Join-Path $ev $n}else{$ev}
        if(Test-Path $p -ErrorAction SilentlyContinue){return $p}}
    return $n}
$envAdb=Find-Tool "adb.exe"
$envAapt2=Find-Tool "aapt2.exe"
$envAaptArm=Find-Tool "aapt-arm-pie2"
$envAaptArmRemote="/data/local/tmp/aapt-arm-pie2"
$env7z=Find-Tool "7z.exe"
$script:AdbAvailable=Test-Path $envAdb -ErrorAction SilentlyContinue
$currentLocalPath="C:\"; $currentAdbPath="/storage/emulated/0"; $script:AndroidStartPath="/storage/emulated/0"
$global:SelectedPaths=New-Object "System.Collections.Generic.HashSet[string]"
$global:ClipboardItems=@(); $global:ClipboardIsAdb=$false
$global:SortPC="Name"; $global:SortPCAsc=$true; $global:SortADB="Name"; $global:SortADBAsc=$true
$script:SearchIsPC=$true; $script:SearchStop=$false; $script:SearchSLV=$null; $script:SearchSW=$null
$script:ArchivePath=""; $script:ArchiveIsPC=$true; $script:ArchiveName=""; $script:ArchiveSubDir=""  # empty = not in archive
$script:AppMode=$false; $script:AppCategory="Select Apps"; $script:AppBaseCategory="All"; $script:AppCategoryChanging=$false; $script:AppFilter=""; $script:AppFilterPhrases=@(); $script:AppFilterMode="All"; $script:AppPackages=@(); $script:LastAdbConnected=$false
$script:CtxItem=$null; $script:CtxLVRef=$null; $script:CtxPath=""; $script:CtxIsPC=$true; $script:CtxIsDir=$false; $script:CtxSnap=@()
$script:LogPaused=$false
$script:StopRequested=$false; $script:CurrentProc=$null
# Editor state - ALL in $script: so named functions can access them from event handlers
$script:EdTx=$null; $script:EdEncBox=$null; $script:EdStEd=$null; $script:EdForm=$null
$script:EdFilePath=""; $script:EdTitle=""; $script:EdIsAdb=$false; $script:EdAdbPath=""
$script:EdIsArchive=$false; $script:EdArchivePath=""; $script:EdArchiveInnerPath=""; $script:EdArchiveTmpDir=""
$script:EdModified=$false; $script:EdClosed=$false; $script:EdFileExt=""; $script:EdHlOn=$false
$script:EdWrapOn=$false; $script:EdBWrap=$null

$extExec=@("exe","bat","cmd","ps1","vbs","wsf","msi","com","scr","pif")
$extText=@("txt","log","cfg","ini","conf","xml","json","yaml","yml","md","csv","nfo","inf","reg","sh","bash", "sql")
$extMedia=@("mp4","mkv","avi","mov","wmv","flv","webm","jpg","jpeg","png","gif","bmp","webp","svg","mp3","wav","flac","aac","ogg")

function Get-FileType{param([string]$n)
    $leaf=($n.TrimEnd("/") -split "[/\\]")[-1];$e="";$dot=$leaf.LastIndexOf(".")
    if($dot -ge 0){$e=$leaf.Substring($dot+1).ToLower()}
    if($e -eq "apk" -or $e -eq "xapk" -or $e -eq "apks"){return "apk"}
    $archExts2=@("zip","7z","rar","gz","tar","bz2","xz","cab","iso","tgz","tbz2","z01","z02","z03","z04","z05")
    if($archExts2-contains $e){return "arch"}
    # Multivolume: .001 .002 ... or .partN.rar pattern, or .7z.1 / .7z.2 / .7z.001 style
    if($e -match "^[0-9]{2,3}$"){return "arch"}
    if($n -match "\.part[0-9]+\.rar$"){return "arch"}
    if($n -match "(?i)\.7z\.[0-9]+$"){return "arch"}
    if($extExec-contains $e){return "exec"};if($extText-contains $e){return "text"}
    if($extMedia-contains $e){return "media"}
    if($n.EndsWith("/")){return "dir"};return "other"}


function Get-FileColor{param([string]$n,[bool]$isDir=$false)
    $archExts=@("zip","7z","rar","gz","tar","bz2","xz","cab","iso","tgz","tbz2","z01","z02","z03","z04","z05")
    if($n -eq ".. [Go Up]"){return [System.Drawing.Color]::FromArgb(130,128,122)}
    if($isDir -or $n.Contains(":\")){return [System.Drawing.Color]::FromArgb(255,255,255)}
    $ext2="";$d2=$n.LastIndexOf(".");if($d2 -ge 0){$ext2=$n.Substring($d2+1).ToLower()}
    if($archExts -contains $ext2 -and $ext2 -ne "apk"){return [System.Drawing.Color]::FromArgb(0,255,0)}
    if($ext2 -match "^[0-9]{2,3}$" -or $n -match "\.part[0-9]+\.rar$" -or $n -match "(?i)\.7z\.[0-9]+$"){return [System.Drawing.Color]::FromArgb(0,255,0)}
    switch(Get-FileType $n){"exec"{return [System.Drawing.Color]::FromArgb(0,255,255)}"text"{return [System.Drawing.Color]::FromArgb(0,140,0)}
        "media"{return [System.Drawing.Color]::FromArgb(80,150,255)}"apk"{return [System.Drawing.Color]::FromArgb(200,115,255)}
        default{return [System.Drawing.Color]::FromArgb(192,192,192)}}}

$bgForm=[System.Drawing.Color]::FromArgb(42,42,46); $bgActive=[System.Drawing.Color]::FromArgb(30,30,34)
$bgInact=[System.Drawing.Color]::FromArgb(22,22,26); $bgHdr=[System.Drawing.Color]::FromArgb(34,34,40)
$curAct=[System.Drawing.Color]::FromArgb(28,98,178); $curInact=[System.Drawing.Color]::FromArgb(58,58,72)
$markClr=[System.Drawing.Color]::FromArgb(255,222,40); $ctxHiClr=[System.Drawing.Color]::FromArgb(48,48,62)
$clrText=[System.Drawing.Color]::FromArgb(210,208,202); $clrDim=[System.Drawing.Color]::FromArgb(150,148,142)
$clrStatus=[System.Drawing.Color]::DeepSkyBlue
$clrGold=[System.Drawing.Color]::FromArgb(212,188,82); $clrLabel=[System.Drawing.Color]::FromArgb(100,180,240)
$ROW_H=22
$fntItem=New-Object System.Drawing.Font("Segoe UI",9.5)
$fntHdr=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$fntPath=New-Object System.Drawing.Font("Consolas",10,[System.Drawing.FontStyle]::Bold)
$fntEd=New-Object System.Drawing.Font("Consolas",12)
$sfVC=New-Object System.Drawing.StringFormat
$sfVC.LineAlignment=[System.Drawing.StringAlignment]::Center
$sfVC.Alignment=[System.Drawing.StringAlignment]::Near
$sfVC.FormatFlags=[System.Drawing.StringFormatFlags]::NoWrap

function Format-Bytes{param([long]$b)
    if($b -gt 1GB){return "{0:N1} GB"-f($b/1GB)};if($b -gt 1MB){return "{0:N1} MB"-f($b/1MB)}
    if($b -gt 1KB){return "{0:N1} KB"-f($b/1KB)};if($b -ge 0){return "$b B"};return ""}
function Get-LocalSize{param($p)
    if(Test-Path $p -PathType Leaf){return(Get-Item $p -ErrorAction SilentlyContinue).Length}
    if(Test-Path $p -PathType Container){return(Get-ChildItem $p -Recurse -File -ErrorAction SilentlyContinue|Measure-Object -Property Length -Sum).Sum}
    return 0L}
function Get-AaptPkg{param([string]$apk)
    try{$o=& "$envAapt2" dump badging "`"$apk`"" 2>&1|Select-Object -First 5
        foreach($l in $o){if($l -match "^package:\s+name='([^']+)'"){return $Matches[1]}}}catch{};return $null}
function Get-AaptLabel{param([string]$apk)
    if(-not (Test-Path $envAapt2 -ErrorAction SilentlyContinue)){return $null}
    try{
        $o=& "$envAapt2" dump badging "`"$apk`"" 2>&1
        foreach($l in $o){
            $ls=[string]$l
            if($ls -match "application-label:'([^']*)'"){return $Matches[1]}
        }
    }catch{}
    return $null
}
$script:AppNameCache=@{}
$script:AppNamesBuilding=$false
$script:AppNamesCompletedUntil=[datetime]::MinValue
$script:AppNamesShowCompleted=$false
$script:AppNamesCancel=$false
$script:AppNamesPrompting=$false
$script:AppNamesPrompted=$false
$script:AppNamesTotal=0
$script:AppNamesRead=0
$script:SkipAppNameBuildOnce=$false
function Test-AaptArmOnDevice {
    if(-not $script:AdbAvailable){return $false}
    try{
        $o=& "$envAdb" shell "test -x /data/local/tmp/aapt-arm-pie2; echo `$?" 2>&1
        return ((@($o) -join "").Trim() -eq "0")
    }catch{return $false}
}
function Ensure-AaptArmOnDevice {
    if(Test-AaptArmOnDevice){return $true}
    if(-not (Test-Path $envAaptArm -ErrorAction SilentlyContinue)){return $false}
    try{
        & "$envAdb" push "$envAaptArm" /data/local/tmp/aapt-arm-pie2 2>&1 | Out-Null
        & "$envAdb" shell chmod 0755 /data/local/tmp/aapt-arm-pie2 2>&1 | Out-Null
        return (Test-AaptArmOnDevice)
    }catch{return $false}
}
function Get-AppLabelFromPackage {
    param([string]$pkg,[bool]$AllowPull=$true)
    if($script:AppNameCache.ContainsKey($pkg)){return $script:AppNameCache[$pkg]}
    if(-not $AllowPull -or -not $script:AdbAvailable){return $null}
    try{
        $paths=@(& "$envAdb" shell pm path $pkg 2>&1 | ForEach-Object { ([string]$_).Trim() } | Where-Object {$_ -match '^package:'})
        $base=$null
        foreach($x in $paths){$rp=$x -replace '^package:',''; if($rp -match '/base\.apk$'){$base=$rp;break}}
        if(-not $base -and $paths.Count -gt 0){$base=($paths[0] -replace '^package:','')}
        if($base){
            $tmp=Join-Path $env:TEMP ("adbcm_label_"+[guid]::NewGuid().ToString('N')+'.apk')
            & "$envAdb" pull "$base" "$tmp" 2>&1 | Out-Null
            if(Test-Path $tmp){$label=Get-AaptLabel $tmp;Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
                if($label -and $label.Trim()){ $script:AppNameCache[$pkg]=$label.Trim(); return $label.Trim() }}
        }
    }catch{}
    return $null
}
function Build-AppNameCacheOnDevice {
    param([string[]]$Packages)

    $list=@($Packages | Where-Object {$_} | Sort-Object -Unique)
    if($list.Count -eq 0){return $true}
    if(-not (Ensure-AaptArmOnDevice)){return $false}

    $i=0
    foreach($pkg in $list){
        if(-not $appNamesBox.Checked -or $script:AppNamesCancel){
            $script:AppNamesCancel=$true
            Set-Status (T "st_cancelling_appnames") "Blue"
            $form.Refresh()
            [System.Windows.Forms.Application]::DoEvents()
            break
        }

        $i++
        $label=$null

        try{
            # Get the APK path directly on the Quest.
            $pathOutput=& "$envAdb" shell "pm path $pkg 2>/dev/null" 2>&1
            $apkPaths=@(
                $pathOutput |
                    ForEach-Object { ([string]$_ -replace '^package:','').Trim() } |
                    Where-Object { $_ -and ($_ -match '/base\.apk$') }
            )

            if($apkPaths.Count -eq 0){
                $apkPaths=@(
                    $pathOutput |
                        ForEach-Object { ([string]$_ -replace '^package:','').Trim() } |
                        Where-Object { $_ }
                )
            }

            $apkPath=if($apkPaths.Count -gt 0){[string]$apkPaths[0]}else{$null}

            if($apkPath){
                # This is intentionally done exactly like the known-working
                # aapt-arm-pie2 test: run aapt on the Quest and parse its output
                # on the PC.
                $badging=& "$envAdb" shell "$envAaptArmRemote d badging '$apkPath' 2>/dev/null" 2>&1
                $labelLine=$badging | Select-String "application: label=" | Select-Object -First 1

                if($labelLine -and ([string]$labelLine.Line -match "label='([^']+)'")){
                    $label=$Matches[1]
                }
            }
        }catch{
            Add-Log "Could not read application name for ${pkg}: $($_.Exception.Message)" "Yellow" -Level Detailed
        }

        if([string]::IsNullOrWhiteSpace($label)){$label=$pkg}
        $script:AppNameCache[$pkg]=[string]$label
        $script:AppNamesRead=$i

        Update-AppNamesStatus
        $form.Refresh()
        [System.Windows.Forms.Application]::DoEvents()
    }

    return (-not $script:AppNamesCancel)
}

function Get-AppDisplayName {
    param([string]$pkg)
    $label=Get-AppLabelFromPackage $pkg $true
    if($label){return $label}
    return $pkg
}

function Detect-Encoding{param([byte[]]$bytes)
    if($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF){return @{Enc=[System.Text.Encoding]::UTF8;Name="UTF-8 with BOM"}}
    if($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE){return @{Enc=[System.Text.Encoding]::Unicode;Name="UTF-8 with BOM"}}
    $isU8=$true;$i=0;$hasHigh=$false
    while($i -lt $bytes.Length -and $isU8){$b=$bytes[$i];if($b -lt 0x80){$i++;continue};$hasHigh=$true
        if($b -ge 0xC2 -and $b -le 0xDF){$cont=1}elseif($b -ge 0xE0 -and $b -le 0xEF){$cont=2}elseif($b -ge 0xF0 -and $b -le 0xF4){$cont=3}else{$isU8=$false;break}
        for($j=1;$j -le $cont;$j++){if(($i+$j) -ge $bytes.Length -or $bytes[$i+$j] -lt 0x80 -or $bytes[$i+$j] -gt 0xBF){$isU8=$false;break}};$i+=$cont+1}
    if($isU8 -and $hasHigh){return @{Enc=[System.Text.Encoding]::UTF8;Name="UTF-8"}}
    # Heuristic: OEM 866 range 0x80-0xAF vs Win-1251 range 0xC0-0xDF
    $c866=($bytes|Where-Object{$_ -ge 0x80 -and $_ -le 0xAF}).Count
    $c1251=($bytes|Where-Object{$_ -ge 0xC0 -and $_ -le 0xDF}).Count
    if($c866 -gt $c1251 -and $c866 -gt 0){try{return @{Enc=[System.Text.Encoding]::GetEncoding(866);Name="OEM 866"}}catch{}}
    try{return @{Enc=[System.Text.Encoding]::GetEncoding(1251);Name="Windows-1251"}}catch{return @{Enc=[System.Text.Encoding]::ASCII;Name="ASCII"}}
}
function Get-EncFromName{param([string]$n)
    switch($n){"UTF-8"{return New-Object System.Text.UTF8Encoding($false)}"UTF-8 with BOM"{return New-Object System.Text.UTF8Encoding($true)}
        "Windows-1251"{try{return [System.Text.Encoding]::GetEncoding(1251)}catch{return [System.Text.Encoding]::UTF8}}
        "Windows-1252"{try{return [System.Text.Encoding]::GetEncoding(1252)}catch{return [System.Text.Encoding]::UTF8}}
        "OEM 866"{try{return [System.Text.Encoding]::GetEncoding(866)}catch{return [System.Text.Encoding]::UTF8}}
        "ASCII"{return [System.Text.Encoding]::ASCII}default{return New-Object System.Text.UTF8Encoding($false)}}}

# ==============================================================================
# ФУНКЦИЯ ПОДСВЕТКИ СИНТАКСИСА (ИСПРАВЛЕНА)
# ==============================================================================
function Apply-SyntaxHighlight {
    param(
        [System.Windows.Forms.RichTextBox]$tx,
        [string]$ext,
        [int]$maxLines = 3000
    )

    if ($null -eq $tx -or $script:EdHighlighting) { return }

    $ext = $ext.ToLower()
    $supported = @("ps1", "bat", "cmd", "sh", "bash", "ini", "cfg", "conf", "log", "nfo", "json", "sql")
    if ($ext -notin $supported) { return }

    $defaultColor = if ($null -ne $script:clrText) { $script:clrText } else { [System.Drawing.Color]::FromArgb(220, 220, 220) }

    $wasEdModified = $script:EdModified
    $wasTitle = if ($null -ne $script:EdForm) { $script:EdForm.Text } else { "" }
    
    $script:EdHighlighting = $true
    $script:EdSuppressEvents = $true

    try {
        $tx.SuspendLayout()
        $sp = $tx.SelectionStart
        $sl = $tx.SelectionLength

        # Reset selection color
        $tx.SelectAll()
        $tx.SelectionColor = $defaultColor
        $tx.SelectionBackColor = $tx.BackColor

        $full = $tx.Text

        # Palette definition (brightened for readability on the dark editor background)
        $cKw   = [System.Drawing.Color]::FromArgb(110, 190, 255)  # Keywords
        $cStr  = [System.Drawing.Color]::FromArgb(240, 165, 110)  # Strings
        $cCmt  = [System.Drawing.Color]::FromArgb(130, 200, 90)   # Comments
        $cVar  = [System.Drawing.Color]::FromArgb(175, 235, 255)  # Variables
        $cNum  = [System.Drawing.Color]::FromArgb(195, 235, 150)  # Numbers
        $cOp   = [System.Drawing.Color]::FromArgb(230, 150, 235)  # Operators
        $cEcho = [System.Drawing.Color]::FromArgb(245, 235, 140)  # Output
        $cSec  = [System.Drawing.Color]::FromArgb(90, 225, 195)   # INI Sections
        $cKey  = [System.Drawing.Color]::FromArgb(175, 235, 255)  # Keys
        $cVal  = [System.Drawing.Color]::FromArgb(240, 165, 110)  # Values
        $cErr  = [System.Drawing.Color]::FromArgb(255, 90, 90)    # Errors
        $cWrn  = [System.Drawing.Color]::FromArgb(235, 185, 60)   # Warnings
        $cInf  = [System.Drawing.Color]::FromArgb(90, 225, 195)   # Info
        $cDbg  = [System.Drawing.Color]::FromArgb(165, 165, 195)  # Debug
        $cVarB = [System.Drawing.Color]::FromArgb(195, 245, 115)  # BAT Variables %var%

        if ($ext -eq "ps1") {
            $kwList = @("function","param","if","else","elseif","foreach","for","while","do","switch","return","break","continue","try","catch","finally","throw","class","end","begin","process","filter","trap","exit","in","using","namespace")
            $opList = @("-eq","-ne","-lt","-gt","-le","-ge","-like","-notlike","-match","-notmatch","-contains","-notcontains","-in","-notin","-and","-or","-not","-xor","-band","-bor","-bnot")
        } elseif ($ext -in @("bat", "cmd")) {
            $kwList = @("if","else","for","do","goto","call","set","pause","not","exist","defined","shift","pushd","popd","move","copy","del","mkdir","rmdir","cls","exit","dir","type","find","findstr","setlocal","endlocal")
            $opList = @()
        } elseif ($ext -in @("sh", "bash")) {
            $kwList = @("if","then","else","elif","fi","for","do","done","while","until","case","esac","function","return","break","continue","exit","export","local","readonly","source","echo","printf","read","shift","set","unset","trap")
            $opList = @()
        } elseif ($ext -eq "sql") {
            $kwList = @("select","from","where","insert","update","delete","join","left","right","inner","outer","on","group","by","order","having","limit","create","table","drop","alter","index","into","values","and","or","not","null","is","as")
            $opList = @()
        } else {
            $kwList = @()
            $opList = @()
        }

        $linesArr = $full -split "`n"
        $charPos = 0
        $lineCount = 0

        foreach ($ln in $linesArr) {
            $lineCount++
            if ($lineCount -gt $maxLines) { break }
            $llen = $ln.Length
            $trimmed = $ln.TrimStart()

            # INI / CFG / CONF
            if ($ext -in @("ini", "cfg", "conf")) {
                if ($trimmed.StartsWith("[") -and $trimmed.Contains("]")) { $tx.Select($charPos, $llen); $tx.SelectionColor = $cSec; $charPos += $llen + 1; continue }
                if ($trimmed.StartsWith(";") -or $trimmed.StartsWith("#")) { $tx.Select($charPos, $llen); $tx.SelectionColor = $cCmt; $charPos += $llen + 1; continue }
                $eq = $ln.IndexOf("=")
                if ($eq -gt 0) {
                    $tx.Select($charPos, $eq); $tx.SelectionColor = $cKey
                    $tx.Select($charPos + $eq, $llen - $eq); $tx.SelectionColor = $cVal
                }
                $charPos += $llen + 1
                continue
            }

            # LOG / NFO
            if ($ext -in @("log", "nfo")) {
                $up = $trimmed.ToUpper()
                if ($up -match "ERROR|FAIL|FATAL|CRITICAL") { $tx.Select($charPos, $llen); $tx.SelectionColor = $cErr; $charPos += $llen + 1; continue }
                if ($up -match "WARN(ING)?") { $tx.Select($charPos, $llen); $tx.SelectionColor = $cWrn; $charPos += $llen + 1; continue }
                if ($up -match "INFO|OK|SUCCESS|DONE|COMPLETE") { $tx.Select($charPos, $llen); $tx.SelectionColor = $cInf; $charPos += $llen + 1; continue }
                if ($up -match "DEBUG|TRACE|VERBOSE") { $tx.Select($charPos, $llen); $tx.SelectionColor = $cDbg; $charPos += $llen + 1; continue }
                $charPos += $llen + 1
                continue
            }

            # JSON
            if ($ext -eq "json") {
                $colIdx = $ln.IndexOf(":")
                if ($colIdx -gt 0) {
                    $tx.Select($charPos, $colIdx); $tx.SelectionColor = $cKey
                    $tx.Select($charPos + $colIdx, $llen - $colIdx); $tx.SelectionColor = $cVal
                }
                $charPos += $llen + 1
                continue
            }

            # Comments
            $isCmt = $false
            if ($ext -in @("bat", "cmd") -and ($trimmed -match "(?i)^rem($|\s)" -or $trimmed.StartsWith("::"))) { $isCmt = $true }
            elseif ($ext -in @("sh", "bash", "ps1") -and $trimmed.StartsWith("#")) { $isCmt = $true }
            elseif ($ext -eq "sql" -and $trimmed.StartsWith("--")) { $isCmt = $true }
            if ($isCmt) { $tx.Select($charPos, $llen); $tx.SelectionColor = $cCmt; $charPos += $llen + 1; continue }

            # Echo output
            $isEcho = $false
            if ($ext -in @("bat", "cmd") -and $trimmed -match "(?i)^echo($|\s)") { $isEcho = $true }
            if ($ext -eq "ps1" -and $trimmed -match "(?i)^(Write-Host|Write-Output|Write-Warning|Write-Error|Write-Verbose)($|\s)") { $isEcho = $true }
            if ($isEcho) { $tx.Select($charPos, $llen); $tx.SelectionColor = $cEcho; $charPos += $llen + 1; continue }

            # Inline PowerShell comments
            if ($ext -eq "ps1") {
                $ci = $ln.IndexOf(" #")
                if ($ci -ge 0 -and $ci -lt $llen - 1) {
                    $tx.Select($charPos + $ci + 1, $llen - $ci - 1)
                    $tx.SelectionColor = $cCmt
                }
            }

            # Double quotes
            $si = 0
            while ($si -lt $llen) {
                $qi = $ln.IndexOf("`"", $si)
                if ($qi -lt 0) { break }
                $qi2 = $ln.IndexOf("`"", $qi + 1)
                if ($qi2 -lt 0) { $qi2 = $llen - 1 }
                $tx.Select($charPos + $qi, $qi2 - $qi + 1)
                $tx.SelectionColor = $cStr
                $si = $qi2 + 1
            }

            # Single quotes
            if ($ext -in @('ps1', 'sh', 'bash', 'sql')) {
                $si = 0
                while ($si -lt $llen) {
                    $qi = $ln.IndexOf("'", $si)
                    if ($qi -lt 0) { break }
                    $qi2 = $ln.IndexOf("'", $qi + 1)
                    if ($qi2 -lt 0) { $qi2 = $llen - 1 }
                    $tx.Select($charPos + $qi, $qi2 - $qi + 1)
                    $tx.SelectionColor = $cStr
                    $si = $qi2 + 1
                }
            }

            # Variables $var
            if ($ext -in @('ps1', 'sh', 'bash')) {
                $si = 0
                while ($si -lt $llen) {
                    $vi = $ln.IndexOf('$', $si)
                    if ($vi -lt 0) { break }
                    $ve = $vi + 1
                    while ($ve -lt $llen -and $ln[$ve] -match '[a-zA-Z0-9_]') { $ve++ }
                    if ($ve -gt $vi + 1) {
                        $tx.Select($charPos + $vi, $ve - $vi)
                        $tx.SelectionColor = $cVar
                    }
                    $si = $ve
                }
            }
            # Variables %var%
            elseif ($ext -in @("bat", "cmd")) {
                $si = 0
                while ($si -lt $llen) {
                    $vi = $ln.IndexOf("%", $si)
                    if ($vi -lt 0) { break }
                    $ve = $ln.IndexOf("%", $vi + 1)
                    if ($ve -lt 0) { break }
                    $tx.Select($charPos + $vi, $ve - $vi + 1)
                    $tx.SelectionColor = $cVarB
                    $si = $ve + 1
                }
            }

            # Keywords
            foreach ($kw in $kwList) {
                $si = 0
                while ($si -lt $llen) {
                    $idx = $ln.IndexOf($kw, $si, [System.StringComparison]::OrdinalIgnoreCase)
                    if ($idx -lt 0) { break }
                    $pre = if ($idx -gt 0) { $ln[$idx - 1] } else { " " }
                    $suf = if ($idx + $kw.Length -lt $llen) { $ln[$idx + $kw.Length] } else { " " }
                    if (-not ($pre -match "[a-zA-Z0-9_-]") -and -not ($suf -match "[a-zA-Z0-9_-]")) {
                        $tx.Select($charPos + $idx, $kw.Length)
                        $tx.SelectionColor = $cKw
                    }
                    $si = $idx + $kw.Length
                }
            }

            # Operators
            foreach ($op in $opList) {
                $si = 0
                while ($si -lt $llen) {
                    $idx = $ln.IndexOf($op, $si, [System.StringComparison]::OrdinalIgnoreCase)
                    if ($idx -lt 0) { break }
                    $suf = if ($idx + $op.Length -lt $llen) { $ln[$idx + $op.Length] } else { " " }
                    if (-not ($suf -match "[a-zA-Z0-9]")) {
                        $tx.Select($charPos + $idx, $op.Length)
                        $tx.SelectionColor = $cOp
                    }
                    $si = $idx + $op.Length
                }
            }

            # Numbers
            $si = 0
            while ($si -lt $llen) {
                if ($ln[$si] -match "[0-9]") {
                    $pre2 = if ($si -gt 0) { $ln[$si - 1] } else { " " }
                    if (-not ($pre2 -match "[a-zA-Z_]")) {
                        $ne = $si
                        while ($ne -lt $llen -and $ln[$ne] -match "[0-9.]") { $ne++ }
                        $tx.Select($charPos + $si, $ne - $si)
                        $tx.SelectionColor = $cNum
                        $si = $ne
                        continue
                    }
                }
                $si++
            }

            $charPos += $llen + 1
        }

        $tx.Select($sp, $sl)
    }
    finally {
        $tx.ResumeLayout()
        $script:EdHighlighting = $false
        $script:EdSuppressEvents = $false
        $script:EdModified = $wasEdModified
        if ($null -ne $script:EdForm) { $script:EdForm.Text = $wasTitle }
    }
}



function Ed-Save {
    if ($null -eq $script:EdFilePath -or $null -eq $script:EdTx) { return }
    
    # Берем кодировку из списка "Convert to:"
    $targetEncName = [string]$script:EdSaveEncBox.SelectedItem
    $targetEncoding = Get-SafeEncoding -encName $targetEncName

    try {
        # Получаем текущий текст из редактора
        $textToSave = $script:EdTx.Text
        
        # Конвертируем текст в байты целевой кодировки
        $bytesToSave = $targetEncoding.GetBytes($textToSave)
        
        # Записываем новые байты в файл на диске
        [System.IO.File]::WriteAllBytes($script:EdFilePath, $bytesToSave)

        if($script:EdIsAdb -and $script:EdAdbPath -ne ""){
            $pushOut=@(& "$envAdb" push "$script:EdFilePath" "$script:EdAdbPath" 2>&1)
            if($LASTEXITCODE -ne 0){
                throw "$(T 'ed_failed_transfer_android'): $($pushOut -join ' ')"
            }
            Add-Log "$(T 'ed_saved_to_android'): $script:EdAdbPath" "Green" -Level Important
        }
        
        # Обновляем байты в памяти редактора
        $script:EdRawBytes = $bytesToSave

        $archSaved = $true
        if ($script:EdIsArchive -and $script:EdArchivePath -ne "" -and $script:EdArchiveInnerPath -ne "") {
            $archSaved = Update-FileInArchive $script:EdArchivePath $script:EdArchiveInnerPath $script:EdArchiveTmpDir
            if (-not $archSaved) {
                [System.Windows.Forms.MessageBox]::Show(
                    (T "ed_msg_archive_update_failed"),
                    (T "ed_archive_error_title"), "OK", "Warning") | Out-Null
            }
        }
        
        # Синхронизируем список "View:" с новой кодировкой сохраненного файла
        $script:EdSuppressEvents = $true
        $script:EdViewEncBox.SelectedItem = $targetEncName
        $script:EdSuppressEvents = $false

        # Сбрасываем флаг изменений
        $script:EdModified = $false
        if ($null -ne $script:EdForm) {
            $script:EdForm.Text = $script:EdTitle
        }
        if ($null -ne $script:EdStEd) {
            if ($script:EdIsArchive -and $archSaved) {
                $archLeaf = Split-Path $script:EdArchivePath -Leaf
                $script:EdStEd.Text = "  $archLeaf :: $($script:EdArchiveInnerPath)  [$(T 'ed_saved_to_archive'), $targetEncName]"
            } else {
                $script:EdStEd.Text = "  $script:EdFilePath  [$(T 'ed_saved_and_converted'): $targetEncName]"
            }
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("$(T 'ed_error_saving'):`n$_", (T "ed_error_title"), "OK", "Error")
    }
}

function Ed-AskSave{
    return [System.Windows.Forms.MessageBox]::Show((T "ed_unsaved_body"),(T "ed_unsaved_title"),[System.Windows.Forms.MessageBoxButtons]::YesNoCancel,[System.Windows.Forms.MessageBoxIcon]::Warning)}

#function Ed-Close{
#    if($null -eq $script:EdForm){return}
#    if($script:EdModified){$r=Ed-AskSave
#        if($r -eq [System.Windows.Forms.DialogResult]::Yes){Ed-Save;$script:EdClosed=$true;$script:EdForm.Close()}
#        elseif($r -eq [System.Windows.Forms.DialogResult]::No){$script:EdClosed=$true;$script:EdForm.Close()}
#    }else{$script:EdClosed=$true;$script:EdForm.Close()}}

# ==============================================================================
# ФУНКЦИЯ ЗАКРЫТИЯ ОКНА (ИСПРАВЛЕНА)
# ==============================================================================
function Ed-Close {
    # Функция только отправляет команду на закрытие формы.
    # Вся логика проверки несохраненных изменений перенесена в FormClosing.
    if ($null -ne $script:EdForm) {
        $script:EdForm.Close()
    }
}

function Ed-ToggleWrap{
    if($null -eq $script:EdTx){return}
    $script:EdWrapOn=-not $script:EdWrapOn
    if($script:EdWrapOn){$script:EdTx.WordWrap=$true;$script:EdTx.ScrollBars="Vertical"
        if($null -ne $script:EdBWrap){$script:EdBWrap.Text="Wrap:ON";$script:EdBWrap.ForeColor=$clrGold}
    }else{$script:EdTx.WordWrap=$false;$script:EdTx.ScrollBars="Both"
        if($null -ne $script:EdBWrap){$script:EdBWrap.Text="Wrap:OFF";$script:EdBWrap.ForeColor=$clrDim}}}

# ==============================================================================
# ФУНКЦИЯ ПОИСКА И ПОДСВЕТКИ ТЕКСТА
# ==============================================================================
function Ed-Search {
    param(
        [string]$query
    )

    if ($null -eq $script:EdTx -or [string]::IsNullOrEmpty($query)) {
        $script:EdSearchIndices = @()
        $script:EdSearchCurrentIndex = -1
        $script:EdSearchQueryLength = 0
        return 0
    }

    # Сохраняем длину подсвечиваемого текста
    $script:EdSearchQueryLength = $query.Length

    $script:EdSuppressEvents = $true
    try {
        $script:EdTx.SuspendLayout()

        # Сохраняем текущее положение курсора
        $startPos = $script:EdTx.SelectionStart
        $selLen   = $script:EdTx.SelectionLength

        # 1. Сброс предыдущей подсветки
        $script:EdTx.SelectAll()
        $script:EdTx.SelectionBackColor = $script:EdTx.BackColor

        if ($script:EdHlOn) {
            Apply-SyntaxHighlight $script:EdTx $script:EdFileExt
        } else {
            $script:EdTx.SelectionColor = $clrText
        }

        # 2. Поиск совпадений и выделение желтым цветом
        $script:EdSearchIndices = @()
        $script:EdSearchCurrentIndex = -1
        $text = $script:EdTx.Text
        $index = 0

        while (($index = $text.IndexOf($query, $index, [System.StringComparison]::OrdinalIgnoreCase)) -ge 0) {
            $script:EdSearchIndices += $index

            $script:EdTx.Select($index, $query.Length)
            $script:EdTx.SelectionBackColor = [System.Drawing.Color]::Yellow
            $script:EdTx.SelectionColor     = [System.Drawing.Color]::Black

            $index += $query.Length
        }

        # 3. Возврат курсора на исходную позицию
        $script:EdTx.Select($startPos, $selLen)

    } finally {
        $script:EdTx.ResumeLayout()
        $script:EdSuppressEvents = $false
    }

    return $script:EdSearchIndices.Count
}

# ==============================================================================
# ФУНКЦИЯ НАВИГАЦИИ ПО НАЙДЕННЫМ СОВПАДЕНИЯМ (ИСПРАВЛЕНА)
# ==============================================================================
function Ed-SearchNext {
    param(
        [bool]$reverse = $false
    )

    if ($null -eq $script:EdSearchIndices -or $script:EdSearchIndices.Count -eq 0) { 
        return 
    }

    # Изменение индекса в зависимости от направления (< или >)
    if ($reverse) {
        $script:EdSearchCurrentIndex--
        if ($script:EdSearchCurrentIndex -lt 0) {
            $script:EdSearchCurrentIndex = $script:EdSearchIndices.Count - 1
        }
    } else {
        $script:EdSearchCurrentIndex++
        if ($script:EdSearchCurrentIndex -ge $script:EdSearchIndices.Count) {
            $script:EdSearchCurrentIndex = 0
        }
    }

    $pos = $script:EdSearchIndices[$script:EdSearchCurrentIndex]
    $qLen = $script:EdSearchQueryLength

    # Прокрутка и выделение найденного элемента без вызова Controls.Find
    if ($qLen -gt 0) {
        $script:EdTx.Select($pos, $qLen)
        $script:EdTx.ScrollToCaret()
    }

    if ($null -ne $script:EdSbLbl) {
        $script:EdSbLbl.Text = "  $($script:EdSearchCurrentIndex + 1)/$($script:EdSearchIndices.Count) found"
    }
}


function Set-Status{param([string]$t,[string]$col="Blue")
    $c=switch($col){
        "Green"{[System.Drawing.Color]::FromArgb(88,200,108)}
        "Red"{[System.Drawing.Color]::FromArgb(210,88,78)}
        "Yellow"{[System.Drawing.Color]::FromArgb(230,190,80)}
        "Blue"{ $clrStatus }
        default{ $clrStatus }
    }
    $stBar.Text=$t;$stBar.ForeColor=$c;$form.Update()}


# ======= Diagnostics / Logging =====================================================
# Output: Off / Window / File / Both
# Level:  Error / Important / Detailed / Debug
$script:LogOutput="Window"
$script:LogLevel="Important"
$script:LogSettingsForm=$null

function Add-Log{
    param(
        [string]$t,
        [string]$col="Gray",
        [ValidateSet("Auto","Error","Important","Detailed","Debug")]
        [string]$Level="Auto"
    )

    $entry="[$([System.DateTime]::Now.ToString("HH\:mm\:ss"))] $t"

    # Keep the old colour-based calls working:
    # Red=Error, Green=Important, everything else=Detailed.
    $effectiveLevel=$Level
    if($effectiveLevel -eq "Auto"){
        $effectiveLevel=switch($col){
            "Red"{"Error"}
            "Green"{"Important"}
            default{"Detailed"}
        }
    }

    $rank=@{"Error"=1;"Important"=2;"Detailed"=3;"Debug"=4}
    $levelRank=$rank[$effectiveLevel]
    $selectedRank=$rank[$script:LogLevel]

    $writeWindow=($script:LogOutput -eq "Window" -or $script:LogOutput -eq "Both")
    $writeFile=($script:LogOutput -eq "File" -or $script:LogOutput -eq "Both")

    if($levelRank -le $selectedRank){
        if($writeFile){
            $logFile=Join-Path $env:TEMP "adbcm_debug.log"
            Add-Content -LiteralPath $logFile -Value $entry -ErrorAction SilentlyContinue
        }

        if($writeWindow){
            if($logBox.Items.Count -gt 300){
                $logBox.Items.RemoveAt(0)
            }
            $logBox.Items.Add($entry)|Out-Null
            if(-not $script:LogPaused){
                $logBox.TopIndex=$logBox.Items.Count-1
            }
        }
    }
}

function Show-LogSettings {
    if ($script:LogSettingsForm -and -not $script:LogSettingsForm.IsDisposed) {
        $script:LogSettingsForm.BringToFront()
        $script:LogSettingsForm.Activate()
        return
    }

    $d = New-Object System.Windows.Forms.Form
    $d.Text = (T "dlg_diag_logging")
    $d.Size = New-Object System.Drawing.Size(425, 340)
    $d.MinimumSize = $d.Size
    $d.MaximumSize = $d.Size
    $d.BackColor = $bgForm
    $d.ForeColor = $clrText
    $d.FormBorderStyle = "FixedDialog"
    $d.StartPosition = "CenterParent"
    $d.KeyPreview = $true
    $script:LogSettingsForm = $d

    # --- Блок «Output» ---
    $grpOut = New-Object System.Windows.Forms.GroupBox
    $grpOut.Text = (T "lbl_output")
    $grpOut.Location = New-Object System.Drawing.Point(15, 10)
    $grpOut.Size = New-Object System.Drawing.Size(380, 100)
    $grpOut.ForeColor = $clrText
    $d.Controls.Add($grpOut)

    # Таблица-сетка для ровного размещения 2х2
    $tblOut = New-Object System.Windows.Forms.TableLayoutPanel
    $tblOut.Dock = "Fill"
    $tblOut.Padding = New-Object System.Windows.Forms.Padding(5, 10, 5, 5)
    $tblOut.ColumnCount = 2
    $tblOut.RowCount = 2
    $tblOut.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $tblOut.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $grpOut.Controls.Add($tblOut)

    $outNames = @(
        @((T "log_out_off"), "Off"),
        @((T "log_out_window"), "Window"),
        @((T "log_out_file"), "File"),
        @((T "log_out_both"), "Both")
    )
    $outBtns = @{}
    foreach ($item in $outNames) {
        $rb = New-Object System.Windows.Forms.RadioButton
        $rb.Text = $item[0]
        $rb.Tag = $item[1]
        $rb.AutoSize = $true
        $rb.ForeColor = $clrText
        $rb.BackColor = $bgForm
        $rb.Add_CheckedChanged({
            param($s, $e)
            if ($s.Checked) { $script:LogOutput = [string]$s.Tag }
        })
        $tblOut.Controls.Add($rb)
        $outBtns[$item[1]] = $rb
    }
    if ($outBtns.ContainsKey($script:LogOutput)) {
        $outBtns[$script:LogOutput].Checked = $true
    }

    # --- Блок «Log level» ---
    $grpLvl = New-Object System.Windows.Forms.GroupBox
    $grpLvl.Text = (T "lbl_log_level")
    $grpLvl.Location = New-Object System.Drawing.Point(15, 120)
    $grpLvl.Size = New-Object System.Drawing.Size(380, 100)
    $grpLvl.ForeColor = $clrText
    $d.Controls.Add($grpLvl)

    # Таблица-сетка для ровного размещения 2х2
    $tblLvl = New-Object System.Windows.Forms.TableLayoutPanel
    $tblLvl.Dock = "Fill"
    $tblLvl.Padding = New-Object System.Windows.Forms.Padding(5, 10, 5, 5)
    $tblLvl.ColumnCount = 2
    $tblLvl.RowCount = 2
    $tblLvl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $tblLvl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $grpLvl.Controls.Add($tblLvl)

    $lvlNames = @(
        @((T "log_lvl_errors"), "Error"),
        @((T "log_lvl_errors_important"), "Important"),
        @((T "log_lvl_detailed"), "Detailed"),
        @((T "log_lvl_debug"), "Debug")
    )
    $lvlBtns = @{}
    foreach ($item in $lvlNames) {
        $rb = New-Object System.Windows.Forms.RadioButton
        $rb.Text = $item[0]
        $rb.Tag = $item[1]
        $rb.AutoSize = $true
        $rb.ForeColor = $clrText
        $rb.BackColor = $bgForm
        $rb.Add_CheckedChanged({
            param($s, $e)
            if ($s.Checked) { $script:LogLevel = [string]$s.Tag }
        })
        $tblLvl.Controls.Add($rb)
        $lvlBtns[$item[1]] = $rb
    }
    if ($lvlBtns.ContainsKey($script:LogLevel)) {
        $lvlBtns[$script:LogLevel].Checked = $true
    }

    # --- Подсказка и кнопка закрытия ---
    $lblInfo = New-Object System.Windows.Forms.Label
    $lblInfo.Text = (T "hlp_f12_hint")
    $lblInfo.Location = New-Object System.Drawing.Point(18, 240)
    $lblInfo.Size = New-Object System.Drawing.Size(220, 22)
    $lblInfo.ForeColor = $clrDim
    $d.Controls.Add($lblInfo)

    $btnClose = New-Object System.Windows.Forms.Button
    $btnClose.Text = (T "btn_close")
    $btnClose.Location = New-Object System.Drawing.Point(300, 235)
    $btnClose.Size = New-Object System.Drawing.Size(90, 28)
    $btnClose.FlatStyle = "Flat"
    $btnClose.ForeColor = $clrText
    $btnClose.BackColor = [System.Drawing.Color]::FromArgb(48, 48, 56)
    $btnClose.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(70, 70, 80)
    $btnClose.Add_Click({
        $d.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $d.Close()
    })
    $d.Controls.Add($btnClose)
    $d.CancelButton = $btnClose

    $d.Add_KeyDown({
        param($s, $e)
        if ($e.KeyCode -eq "F12" -or $e.KeyCode -eq "Escape") {
            $e.SuppressKeyPress = $true
            $d.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
            $d.Close()
        }
    })

    $d.Add_FormClosed({ $script:LogSettingsForm = $null })
    $d.ShowDialog($form) | Out-Null
}



function Show-AdbDialog{param($title,$msg,$defVal=$null,$items=@(),$isHelp=$false)
    $d=New-Object System.Windows.Forms.Form;$d.Text=$title;$d.BackColor=$bgForm;$d.ForeColor=$clrText
    $d.FormBorderStyle="FixedDialog";$d.KeyPreview=$true;$d.StartPosition="CenterParent"
    $d.GetType().GetProperty("DoubleBuffered",[System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).SetValue($d,$true,$null)
    if($isHelp){$d.Size="620,640"}elseif($null -ne $defVal){$d.Size="450,200"}else{$d.Size="480,360"}
    $rtb=New-Object System.Windows.Forms.RichTextBox
    $rtb.Location="20,15";$rtb.Size="$([int]($d.ClientSize.Width-40)),$([int]($d.ClientSize.Height-85))"
    $rtb.BackColor=$bgForm;$rtb.ForeColor=$clrText;$rtb.BorderStyle="None";$rtb.ReadOnly=$true
    $rtb.Font=New-Object System.Drawing.Font("Segoe UI",10);$rtb.Cursor=[System.Windows.Forms.Cursors]::Arrow;$rtb.TabStop=$false
    $rtb.AppendText($msg+"`r`n`r`n")
    foreach($i in $items){$rtb.SelectionColor=$markClr;$rtb.AppendText("  $i`r`n");$rtb.SelectionColor=$clrText}
    $d.Controls.Add($rtb);$inp=$null
    if($null -ne $defVal){$rtb.Visible=$false
        $lbl=New-Object System.Windows.Forms.Label;$lbl.Text=$msg;$lbl.Location="20,25";$lbl.Size="410,35";$lbl.TextAlign="MiddleCenter";$d.Controls.Add($lbl)
        $inp=New-Object System.Windows.Forms.TextBox;$inp.Location="50,75";$inp.Width=350;$inp.Text=$defVal
        $inp.BackColor=[System.Drawing.Color]::FromArgb(55,55,62);$inp.ForeColor=$clrText;$d.Controls.Add($inp)}
    $bOk=New-Object System.Windows.Forms.Button;$bOk.Text=(T "btn_ok");$bOk.Size="90,30";$bOk.FlatStyle="Flat";$bOk.DialogResult="OK"
    $bCn=New-Object System.Windows.Forms.Button;$bCn.Text=(T "btn_cancel");$bCn.Size="90,30";$bCn.FlatStyle="Flat";$bCn.DialogResult="Cancel"
    foreach($b in @($bOk,$bCn)){$b.ForeColor=$clrText;$b.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$b.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(78,78,88)}
    $hw=[int]$d.ClientSize.Width;$hh=[int]$d.ClientSize.Height
    $bOk.Location=New-Object System.Drawing.Point([int]($hw/2-100),[int]($hh-46))
    $bCn.Location=New-Object System.Drawing.Point([int]($hw/2+10),[int]($hh-46))
    $d.Controls.AddRange(@($bOk,$bCn));$d.AcceptButton=$bOk;$d.CancelButton=$bCn
    $d.Add_Shown({if($null -ne $inp){$inp.Focus();$inp.SelectAll()}else{$bOk.Focus()}})
    $res=$d.ShowDialog()
    if($res -eq "OK"){if($null -ne $inp){return $inp.Text}else{return $true}};return $null}

# TEXT EDITOR - stores everything in $script:, event handlers call Ed-* named functions

# ==============================================================================
# ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ ДЛЯ БЕЗОПАСНОГО ПОЛУЧЕНИЯ ОБЪЕКТА КОДИРОВКИ
# ==============================================================================
function Get-SafeEncoding ([string]$encName) {
    try {
        [System.Text.Encoding]::RegisterProvider([System.Text.CodePagesEncodingProvider]::Instance)
    } catch {}

    switch ($encName) {
        "UTF-8"          { return [System.Text.UTF8Encoding]::new($false) } # UTF-8 без BOM
        "UTF-8 with BOM" { return [System.Text.UTF8Encoding]::new($true) }  # UTF-8 c BOM
        "UTF-16 LE"      { return [System.Text.Encoding]::Unicode }         # Windows Unicode (LE)
        "UTF-16 BE"      { return [System.Text.Encoding]::BigEndianUnicode }# Big Endian
        "Windows-1251"   { return [System.Text.Encoding]::GetEncoding(1251) }# Кириллица Windows
        "Windows-1252"   { return [System.Text.Encoding]::GetEncoding(1252) }# Западная Европа
        "OEM 866"        { return [System.Text.Encoding]::GetEncoding(866) } # DOS / Консоль
        "ASCII"          { return [System.Text.Encoding]::ASCII }
        default          { return [System.Text.UTF8Encoding]::new($false) }
    }
}

# ==============================================================================
# ФУНКЦИЯ ОКНА РЕДАКТОРА (ИСПРАВЛЕНА)
# ==============================================================================
function Show-TextEditor {
    param(
        [string]$FilePath,
        [string]$Title,
        [bool]$IsAdb = $false,
        [string]$AdbPath = "",
        [bool]$IsArchive = $false,
        [string]$ArchivePath = "",
        [string]$ArchiveInnerPath = "",
        [string]$ArchiveTmpDir = ""
    )

    $script:EdFilePath       = $FilePath
    $script:EdTitle          = $Title
    $script:EdIsAdb          = $IsAdb
    $script:EdAdbPath        = $AdbPath
    $script:EdIsArchive      = $IsArchive
    $script:EdArchivePath    = $ArchivePath
    $script:EdArchiveInnerPath = $ArchiveInnerPath
    $script:EdArchiveTmpDir  = $ArchiveTmpDir
    $script:EdModified       = $false
    $script:EdClosed         = $false
    $script:EdHlOn           = $false
    $script:EdWrapOn         = $false
    $script:EdRawBytes       = $null
    $script:EdSuppressEvents = $true

    $script:EdTmpDirToCleanup = $null
    if ($IsArchive -and $ArchiveTmpDir -ne "") {
        $script:EdTmpDirToCleanup = $ArchiveTmpDir
    } elseif ($FilePath -like "*\AppData\Local\Temp\*" -and -not $IsAdb) {
        $script:EdTmpDirToCleanup = Split-Path $FilePath -Parent
    }

    $dotIdx = $Title.LastIndexOf(".")
    $script:EdFileExt = if ($dotIdx -ge 0) { $Title.Substring($dotIdx + 1).ToLower() } else { "" }

    # Создание формы
    $ed = New-Object System.Windows.Forms.Form
    $ed.Text = "$(T 'ed_title_prefix'): $Title"
    $ed.Size = New-Object System.Drawing.Size(1120, 740)
    $ed.MinimumSize = New-Object System.Drawing.Size(750, 400)
    $ed.BackColor = $bgForm
    $ed.ForeColor = $clrText
    $ed.StartPosition = "CenterParent"
    $ed.FormBorderStyle = "Sizable"
    $ed.KeyPreview = $true
    $script:EdForm = $ed

    # 1. Верхняя панель инструментов (Toolbar)
    $tb = New-Object System.Windows.Forms.Panel
    $tb.Dock = "Top"; $tb.Height = 38
    $tb.BackColor = [System.Drawing.Color]::FromArgb(34, 34, 40)
    $ed.Controls.Add($tb)

    $mkB = {
        param([string]$t2, [int]$x2, [int]$w2 = 110)
        $b = New-Object System.Windows.Forms.Button
        $b.Text = $t2
        $b.Location = New-Object System.Drawing.Point($x2, 5)
        $b.Size = New-Object System.Drawing.Size($w2, 28)
        $b.FlatStyle = "Flat"
        $b.ForeColor = $clrText
        $b.BackColor = [System.Drawing.Color]::FromArgb(52, 52, 60)
        $b.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(78, 78, 88)
        $tb.Controls.Add($b)
        return $b
    }

    $bSave  = &$mkB "Save Ctrl+S" 8 105
    $bSaveC = &$mkB "Save+Close" 118 105
    $bClose = &$mkB "Close Esc" 228 85
    $bWrap  = &$mkB "Wrap:OFF" 318 75
    $bWrap.ForeColor = $clrDim
    $bWrap.BackColor = [System.Drawing.Color]::FromArgb(44, 44, 52)
    $script:EdBWrap  = $bWrap

    $bHl = &$mkB "Syntax: OFF" 398 90
    $bHl.ForeColor = $clrDim
    $bHl.BackColor = [System.Drawing.Color]::FromArgb(44, 44, 52)

    # Выбор кодировки для чтения (View)
    $lblView = New-Object System.Windows.Forms.Label
    $lblView.Text = "View:"
    $lblView.Location = New-Object System.Drawing.Point(495, 10)
    $lblView.Size = New-Object System.Drawing.Size(40, 18)
    $lblView.ForeColor = $clrDim
    $tb.Controls.Add($lblView)

    $viewEncBox = New-Object System.Windows.Forms.ComboBox
    $viewEncBox.Location = New-Object System.Drawing.Point(537, 7)
    $viewEncBox.Size = New-Object System.Drawing.Size(130, 24)
    $viewEncBox.BackColor = [System.Drawing.Color]::FromArgb(52, 52, 60)
    $viewEncBox.ForeColor = $clrText
    $viewEncBox.DropDownStyle = "DropDownList"
    $tb.Controls.Add($viewEncBox)
    $script:EdViewEncBox = $viewEncBox

    # Выбор кодировки для сохранения (Convert to)
    $lblSave = New-Object System.Windows.Forms.Label
    $lblSave.Text = "Convert to:"
    $lblSave.Location = New-Object System.Drawing.Point(675, 10)
    $lblSave.Size = New-Object System.Drawing.Size(75, 18)
    $lblSave.ForeColor = $clrDim
    $tb.Controls.Add($lblSave)

    $saveEncBox = New-Object System.Windows.Forms.ComboBox
    $saveEncBox.Location = New-Object System.Drawing.Point(753, 7)
    $saveEncBox.Size = New-Object System.Drawing.Size(130, 24)
    $saveEncBox.BackColor = [System.Drawing.Color]::FromArgb(52, 52, 60)
    $saveEncBox.ForeColor = $clrText
    $saveEncBox.DropDownStyle = "DropDownList"
    $tb.Controls.Add($saveEncBox)
    $script:EdSaveEncBox = $saveEncBox

    $encList = @("UTF-8", "UTF-8 with BOM", "UTF-16 LE", "UTF-16 BE", "Windows-1251", "Windows-1252", "OEM 866", "ASCII")
    foreach ($item in $encList) {
        $viewEncBox.Items.Add($item) | Out-Null
        $saveEncBox.Items.Add($item) | Out-Null
    }

    # 2. Панель поиска (Search Bar Panel)
    $sbP = New-Object System.Windows.Forms.Panel
    $sbP.Dock = "Top"; $sbP.Height = 32
    $sbP.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 34)
    $ed.Controls.Add($sbP)

    $sbBox = New-Object System.Windows.Forms.TextBox
    $sbBox.Location = New-Object System.Drawing.Point(8, 5)
    $sbBox.Size = New-Object System.Drawing.Size(180, 22)
    $sbBox.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 58)
    $sbBox.ForeColor = $clrText; $sbBox.BorderStyle = "FixedSingle"
    $sbP.Controls.Add($sbBox)

    $bPrev = New-Object System.Windows.Forms.Button
    $bPrev.Text = "<"
    $bPrev.Location = New-Object System.Drawing.Point(192, 5)
    $bPrev.Size = New-Object System.Drawing.Size(30, 20)
    $bPrev.FlatStyle = "Flat"
    $bPrev.ForeColor = $clrText
    $bPrev.BackColor = [System.Drawing.Color]::FromArgb(52, 52, 60)
    $bPrev.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(78, 78, 88)
    $sbP.Controls.Add($bPrev)

    $bNext = New-Object System.Windows.Forms.Button
    $bNext.Text = ">"
    $bNext.Location = New-Object System.Drawing.Point(225, 5)
    $bNext.Size = New-Object System.Drawing.Size(30, 20)
    $bNext.FlatStyle = "Flat"
    $bNext.ForeColor = $clrText
    $bNext.BackColor = [System.Drawing.Color]::FromArgb(52, 52, 60)
    $bNext.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(78, 78, 88)
    $sbP.Controls.Add($bNext)

    $sbLbl = New-Object System.Windows.Forms.Label
    $sbLbl.Location = New-Object System.Drawing.Point(262, 7)
    $sbLbl.Size = New-Object System.Drawing.Size(350, 20)
    $sbLbl.ForeColor = $clrDim
    $sbP.Controls.Add($sbLbl)
    $script:EdSbLbl = $sbLbl

    # 3. Нижняя строка статуса редактора ($stEd / $script:EdStEd)
    $stEd = New-Object System.Windows.Forms.Label
    $stEd.Dock = "Bottom"
    $stEd.Height = 24
    $stEd.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 36)
    $stEd.ForeColor = $clrDim
    $stEd.TextAlign = "MiddleLeft"
    $ed.Controls.Add($stEd)
    $script:EdStEd = $stEd

    # 4. Текстовое поле (RichTextBox)
    $tx = New-Object System.Windows.Forms.RichTextBox
    $tx.Dock = "Fill"; $tx.BorderStyle = "None"; $tx.AcceptsTab = $true
    $tx.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 28)
    $tx.ForeColor = $clrText
    $tx.Font = $fntEd; $tx.ScrollBars = "Both"; $tx.WordWrap = $false
    $ed.Controls.Add($tx)
    $tx.BringToFront()
    $script:EdTx = $tx
$tx.Add_TextChanged({
        if ($script:EdSuppressEvents) { return }
        if (-not $script:EdModified) {
            $script:EdModified = $true
            if ($null -ne $script:EdForm -and -not $script:EdForm.Text.EndsWith(" *")) {
                $script:EdForm.Text += " *"
            }
        }
    })


    # 5. Настройка обработчиков событий
    $bPrev.Add_Click({ Ed-SearchNext -reverse $true })
    $bNext.Add_Click({ Ed-SearchNext -reverse $false })

    $sbBox.Add_TextChanged({
        $q = $this.Text
        if ($null -eq $script:EdSbLbl) { return }
        if ($q.Length -lt 3) {
            $script:EdSbLbl.Text = ""
            $script:EdSearchIndices = @()
            return
        }
        $total = Ed-Search $q
        if ($total -gt 0) {
            $script:EdSbLbl.Text = "  $(T 'ed_search_found' @(1,$total))"
        } else {
            $script:EdSbLbl.Text = "  $(T 'ed_search_notfound')"
        }
    })

    $sbBox.Add_KeyDown({
        param($s, $ev)
        if ($ev.KeyCode -eq "Enter") {
            if ($ev.Shift) {
                Ed-SearchNext -reverse $true
            } else {
                Ed-SearchNext -reverse $false
            }
            $ev.SuppressKeyPress = $true
        }
    })

    $bSave.Add_Click({ Ed-Save })
    $bSaveC.Add_Click({ Ed-Save; $script:EdClosed = $true; if ($null -ne $script:EdForm) { $script:EdForm.Close() } })
    $bClose.Add_Click({ Ed-Close })
    $bWrap.Add_Click({ Ed-ToggleWrap })

    $bHl.Add_Click({
        $script:EdHlOn = -not $script:EdHlOn
        if ($script:EdHlOn) {
            $this.Text = "Syntax: ON"
            $this.ForeColor = $clrGold
            if ($null -ne $script:EdTx) {
                Apply-SyntaxHighlight $script:EdTx $script:EdFileExt
            }
        } else {
            $this.Text = "Syntax: OFF"
            $this.ForeColor = $clrDim
            if ($null -ne $script:EdTx) {
                $script:EdSuppressEvents = $true
                try {
                    $script:EdTx.SuspendLayout()
                    $sp = $script:EdTx.SelectionStart
                    $sl = $script:EdTx.SelectionLength

                    $script:EdTx.SelectAll()
                    $script:EdTx.SelectionColor = $clrText
                    $script:EdTx.SelectionBackColor = $script:EdTx.BackColor

                    $script:EdTx.Select($sp, $sl)
                } finally {
                    $script:EdTx.ResumeLayout()
                    $script:EdSuppressEvents = $false
                }
            }
        }
    })

    # 6. Чтение содержимого файла
    try {
        $fs9 = [System.IO.File]::Open($FilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
        $br9 = New-Object System.IO.BinaryReader($fs9)
        $script:EdRawBytes = $br9.ReadBytes([int]$fs9.Length)
        $br9.Close(); $fs9.Close()

        $det = Detect-Encoding $script:EdRawBytes
        $tx.Clear()
        $tx.Text = $det.Enc.GetString($script:EdRawBytes)

        if ($viewEncBox.Items.Contains($det.Name)) {
            $viewEncBox.SelectedItem = $det.Name
            $saveEncBox.SelectedItem = $det.Name
        } else {
            $viewEncBox.SelectedIndex = 0
            $saveEncBox.SelectedIndex = 0
        }
        $stEd.Text = "  $FilePath  [$(T 'ed_original_encoding'): $($det.Name)]"

    } catch {
        $tx.Text = "$(T 'ed_error_reading_file'): $_"
    }

    $script:EdSuppressEvents = $false

    # Обработчик смены кодировки для просмотра
    $viewEncBox.Add_SelectedIndexChanged({
        param($sender, $e)
        if ($script:EdSuppressEvents -or $null -eq $script:EdRawBytes) { return }
        $selectedEnc = [string]$sender.SelectedItem
        if ([string]::IsNullOrEmpty($selectedEnc)) { return }

        $script:EdSuppressEvents = $true
        try {
            $encObj = Get-SafeEncoding -encName $selectedEnc
            $decodedText = $encObj.GetString($script:EdRawBytes)

            if ($null -ne $script:EdTx) {
                $script:EdTx.Clear()
                $script:EdTx.Text = $decodedText
                $script:EdTx.ForeColor = $clrText

                if ($script:EdHlOn) {
                    Apply-SyntaxHighlight $script:EdTx $script:EdFileExt
                }
            }

            if ($null -ne $script:EdStEd) {
                $script:EdStEd.Text = "  $script:EdFilePath  [View encoding: $selectedEnc]"
            }
        }
        finally {
            $script:EdSuppressEvents = $false
        }
    })

    # Обработчики закрытия и горячих клавиш
    $ed.Add_FormClosing({
        param($s, $ev)
        if ($script:EdModified) {
            $r = Ed-AskSave
            if ($r -eq [System.Windows.Forms.DialogResult]::Yes) { Ed-Save }
            elseif ($r -eq [System.Windows.Forms.DialogResult]::Cancel) { $ev.Cancel = $true }
            else { $script:EdClosed = $true }
        }
        if (-not $ev.Cancel -and $script:EdTmpDirToCleanup -and (Test-Path -LiteralPath $script:EdTmpDirToCleanup)) {
            try {
                Start-Sleep -Milliseconds 100
                Remove-Item -LiteralPath $script:EdTmpDirToCleanup -Recurse -Force -ErrorAction Stop
            } catch {}
        }
    })

    $tx.Add_KeyDown({
        param($s, $ev)
        if ($ev.Control -and $ev.KeyCode -eq "S") { Ed-Save; $ev.SuppressKeyPress = $true }
        if ($ev.KeyCode -eq "Escape") { Ed-Close; $ev.SuppressKeyPress = $true }
    })

    $ed.Add_KeyDown({
        param($s, $ev)
        if ($ev.KeyCode -eq "F2" -and -not $ev.Control -and -not $ev.Alt) { Ed-Save; $ev.SuppressKeyPress = $true }
        if ($ev.KeyCode -eq "Escape") { Ed-Close; $ev.SuppressKeyPress = $true }
    })

    $ed.Add_FormClosed({
        if($script:EdIsAdb -and $script:EdFilePath -and (Test-Path $script:EdFilePath)){Remove-Item -LiteralPath $script:EdFilePath -Force -ErrorAction SilentlyContinue}
    })

    $ed.Add_Shown({
        $this.Activate()
        foreach($ctrl in $this.Controls){
            if($ctrl -is [System.Windows.Forms.RichTextBox]){
                $ctrl.Focus()
                break
            }
        }
    })

    $ed.Show($form)
    $ed.BringToFront()
    $ed.Activate()
}


# MAIN FORM
$form=New-Object System.Windows.Forms.Form;$form.Text="Quas ADB Commander v10.5"
$form.Size="1060,860";$form.MinimumSize="720,620";$form.BackColor=$bgForm
$form.KeyPreview=$true;$form.StartPosition="CenterScreen";$form.FormBorderStyle="Sizable"
$form.GetType().GetProperty("DoubleBuffered",[System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).SetValue($form,$true,$null)

$lblPC=New-Object System.Windows.Forms.Label;$lblPC.Location="15,8";$lblPC.Size="440,20";$lblPC.ForeColor=$clrGold;$lblPC.Font=$fntPath;$form.Controls.Add($lblPC)
$lblPCn=New-Object System.Windows.Forms.Label;$lblPCn.Text="PC";$lblPCn.Size="40,20";$lblPCn.ForeColor=$clrLabel;$lblPCn.Font=$fntHdr;$lblPCn.TextAlign="MiddleRight";$form.Controls.Add($lblPCn)
$lblADB=New-Object System.Windows.Forms.Label;$lblADB.Location="545,8";$lblADB.Size="440,20";$lblADB.ForeColor=$clrGold;$lblADB.Font=$fntPath;$form.Controls.Add($lblADB)
$lblADBn=New-Object System.Windows.Forms.Label;$lblADBn.Text="Android";$lblADBn.Size="62,20";$lblADBn.ForeColor=$clrLabel;$lblADBn.Font=$fntHdr;$lblADBn.TextAlign="MiddleRight";$form.Controls.Add($lblADBn)

function New-Panel-LV{param([int]$x)
    $lv=New-Object NoHScrollListView
    $lv.Location=New-Object System.Drawing.Point($x,56);$lv.Size=New-Object System.Drawing.Size(490,460)
    $lv.View="Details";$lv.FullRowSelect=$true;$lv.GridLines=$false
    $lv.BorderStyle="None";$lv.BackColor=$bgInact;$lv.ForeColor=$clrText
    $lv.Font=$fntItem;$lv.MultiSelect=$false;$lv.OwnerDraw=$true;$lv.HeaderStyle="None"
    $il=New-Object System.Windows.Forms.ImageList;$il.ImageSize=New-Object System.Drawing.Size(1,$ROW_H);$lv.SmallImageList=$il
    $lv.Columns.Add("Name",260)|Out-Null;$lv.Columns.Add("Size",80)|Out-Null;$lv.Columns.Add("Date",130)|Out-Null
    $lv.Add_DrawItem({param($s,$e)
        if($e.Index -lt 0){return}
        $it=$e.Item;$isFoc=($form.ActiveControl -eq $s);$isSel=$it.Selected
        $isCtx=($script:CtxLVRef -eq $s -and $script:CtxItem -eq $it)
        $bg=if($isSel){if($isFoc){$curAct}else{$curInact}}elseif($isCtx){$ctxHiClr}else{$s.BackColor}
        $br=New-Object System.Drawing.SolidBrush($bg);$e.Graphics.FillRectangle($br,$e.Bounds);$br.Dispose()})
    $lv.Add_DrawSubItem({param($s,$e)
        $it=$e.Item;$isFoc=($form.ActiveControl -eq $s);$isSel=$it.Selected
        $isCtx=($script:CtxLVRef -eq $s -and $script:CtxItem -eq $it)
        $ti=Get-ItemTag $it
        $isMarked=($ti.Path -ne "__GOUP__" -and $ti.Path -ne "" -and $global:SelectedPaths.Contains($ti.Path))
        $bg=if($isSel){if($isFoc){$curAct}else{$curInact}}elseif($isCtx){$ctxHiClr}else{$s.BackColor}
        $brBg=New-Object System.Drawing.SolidBrush($bg);$e.Graphics.FillRectangle($brBg,$e.Bounds);$brBg.Dispose()
        if($e.ColumnIndex -eq 0){$fc=if($isMarked){$markClr}elseif($it.Tag -eq "__GOUP__" -or $it.Tag -eq "__ARCHCLOSE__"){$clrDim}elseif($isSel){[System.Drawing.Color]::FromArgb(235,233,227)}else{Get-FileColor $it.Text $ti.IsDir}}
        else{$fc=if($isSel){[System.Drawing.Color]::FromArgb(175,173,167)}else{$clrDim}}
        $brT=New-Object System.Drawing.SolidBrush($fc)
        $r2=New-Object System.Drawing.RectangleF([float]($e.Bounds.X+4),[float]$e.Bounds.Y,[float]($e.Bounds.Width-6),[float]$e.Bounds.Height)
        $e.Graphics.DrawString($e.SubItem.Text,$fntItem,$brT,$r2,$sfVC);$brT.Dispose()})
    $lv.Add_DrawColumnHeader({param($s,$e)
        $br=New-Object System.Drawing.SolidBrush($bgHdr);$e.Graphics.FillRectangle($br,$e.Bounds);$br.Dispose()})
    $lv.Add_DoubleClick({&$navAction});return $lv}
$lvPC=New-Panel-LV 15;$lvADB=New-Panel-LV 545
$form.Controls.AddRange(@($lvPC,$lvADB))

function New-Hdr{param([int]$x,[string]$side)
    $ph=New-Object System.Windows.Forms.Panel;$ph.Location=New-Object System.Drawing.Point($x,32)
    $ph.Size=New-Object System.Drawing.Size(490,24);$ph.BackColor=$bgHdr
    $mkHB={param([string]$dispText,[int]$bx,[int]$bw,[string]$sortKey=$dispText)
        $b=New-Object System.Windows.Forms.Button;$b.Location=New-Object System.Drawing.Point($bx,0);$b.Size=New-Object System.Drawing.Size($bw,24)
        $b.Text=$dispText;$b.FlatStyle="Flat";$b.Font=$fntHdr;$b.TextAlign="MiddleLeft"
        $b.Padding=New-Object System.Windows.Forms.Padding(4,0,0,0);$b.TabStop=$false
        $b.ForeColor=[System.Drawing.Color]::FromArgb(168,166,155);$b.BackColor=$bgHdr
        $b.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(52,52,60)
        $b.FlatAppearance.MouseOverBackColor=[System.Drawing.Color]::FromArgb(48,48,58)
        $sc=$sortKey;$sd=$side
        $b.Add_Click([scriptblock]::Create(@"
            if ('$sd' -eq 'PC') {
                if (`$global:SortPC  -eq '$sc') { `$global:SortPCAsc  = -not `$global:SortPCAsc  }
                else { `$global:SortPC  = '$sc'; `$global:SortPCAsc  = `$true }
                Refresh-Panel 'PC'
            } else {
                if (`$global:SortADB -eq '$sc') { `$global:SortADBAsc = -not `$global:SortADBAsc }
                else { `$global:SortADB = '$sc'; `$global:SortADBAsc = `$true }
                Refresh-Panel 'ADB'
            }
"@))
        $ph.Controls.Add($b);return $b}
    &$mkHB (T "col_name") 0 260 "Name"|Out-Null;&$mkHB (T "col_size") 260 80 "Size"|Out-Null;&$mkHB (T "col_date") 340 130 "Date"|Out-Null
    return $ph}
$hdrPC=New-Hdr 15 "PC";$hdrADB=New-Hdr 545 "ADB"
$form.Controls.AddRange(@($hdrPC,$hdrADB))

$stBar=New-Object System.Windows.Forms.Label;$stBar.Location="15,528";$stBar.Size="1020,20";$stBar.ForeColor=$clrDim;$stBar.TextAlign="MiddleLeft";$stBar.Font=(New-Object System.Drawing.Font("Segoe UI",10.5));$form.Controls.Add($stBar)

$appFilterStatus=New-Object System.Windows.Forms.Label
$appFilterStatus.Text=""
$appFilterStatus.ForeColor=[System.Drawing.Color]::FromArgb(230,190,80)
$appFilterStatus.TextAlign="MiddleLeft"
$appFilterStatus.AutoEllipsis=$true
$appFilterStatus.Font=$fntItem
$appFilterStatus.Visible=$false
$form.Controls.Add($appFilterStatus)

$appFilterPhrasesStatus=New-Object System.Windows.Forms.Label
$appFilterPhrasesStatus.Text=""
$appFilterPhrasesStatus.ForeColor=[System.Drawing.Color]::DeepSkyBlue
$appFilterPhrasesStatus.TextAlign="MiddleLeft"
$appFilterPhrasesStatus.AutoEllipsis=$true
$appFilterPhrasesStatus.Font=$fntItem
$appFilterPhrasesStatus.Visible=$false
$form.Controls.Add($appFilterPhrasesStatus)

$appFilterModeStatus=New-Object System.Windows.Forms.Label
$appFilterModeStatus.Text=""
$appFilterModeStatus.ForeColor=[System.Drawing.Color]::FromArgb(80,150,255)
$appFilterModeStatus.TextAlign="MiddleLeft"
$appFilterModeStatus.AutoEllipsis=$true
$appFilterModeStatus.Font=$fntItem
$appFilterModeStatus.Visible=$false
$form.Controls.Add($appFilterModeStatus)

$appCatBox=New-Object System.Windows.Forms.ComboBox
$appCatBox.DropDownStyle="DropDownList"
$appCatBox.Items.AddRange(@("Select Apps","All","System","Third-Party","Enabled","Disabled","Filtered","Removed","Update System"))
$appCatBox.BackColor=[System.Drawing.Color]::FromArgb(52,52,60)
$appCatBox.ForeColor=$clrText
$appCatBox.FlatStyle="Flat"
$appCatBox.Font=$fntItem
$appCatBox.TabStop=$false
# Items stay in English (used internally as category keys throughout the code);
# only the displayed text is translated, via owner-draw, so RU/EN switching never
# desyncs the dropdown's value from the app's category-comparison logic.
$script:AppCatKeyMap=@{
    "Select Apps"="cat_select_apps";"All"="cat_all";"System"="cat_system"
    "Third-Party"="cat_third_party";"Enabled"="cat_enabled";"Disabled"="cat_disabled"
    "Filtered"="cat_filtered";"Removed"="cat_removed";"Update System"="cat_update_system"}
$appCatBox.DrawMode="OwnerDrawFixed"
$appCatBox.Add_DrawItem({
    param($s,$e)
    $e.DrawBackground()
    if($e.Index -ge 0){
        $raw=[string]$s.Items[$e.Index]
        $disp=if($script:AppCatKeyMap.ContainsKey($raw)){T $script:AppCatKeyMap[$raw]}else{$raw}
        $fg=if(($e.State -band [System.Windows.Forms.DrawItemState]::Selected) -ne 0){$clrText}else{$s.ForeColor}
        [System.Windows.Forms.TextRenderer]::DrawText($e.Graphics,$disp,$s.Font,$e.Bounds,$fg,[System.Windows.Forms.TextFormatFlags]::VerticalCenter -bor [System.Windows.Forms.TextFormatFlags]::Left)
    }
    $e.DrawFocusRectangle()})
$appCatBox.Add_SelectedIndexChanged({
    if($null -eq $this.SelectedItem -or $script:AppCategoryChanging){return}
    if(Get-Command Set-AppCategory -ErrorAction SilentlyContinue){Set-AppCategory ([string]$this.SelectedItem)}
})
$form.Controls.Add($appCatBox)

$appNamesBox=New-Object System.Windows.Forms.CheckBox
$appNamesBox.Text="AppNames"
$appNamesBox.AutoSize=$true
$appNamesBox.ForeColor=$clrText
$appNamesBox.BackColor=$bgForm
$appNamesBox.Visible=$false
$appNamesBox.TabStop=$false
$appNamesBox.Add_CheckedChanged({
    # Update the A button immediately, before any potentially long name scan.
    if($appNamesBtn){
        if($this.Checked){
            $appNamesBtn.BackColor=[System.Drawing.Color]::FromArgb(80,150,255)
            $appNamesBtn.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(110,170,255)
            $appNamesBtn.ForeColor=[System.Drawing.Color]::White
        }else{
            $appNamesBtn.BackColor=[System.Drawing.Color]::FromArgb(52,52,60)
            $appNamesBtn.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(78,78,88)
            $appNamesBtn.ForeColor=$clrText
        }
        $appNamesBtn.Refresh()
        [System.Windows.Forms.Application]::DoEvents()
    }
    if(-not $script:AppMode -or $script:AppCategory -eq "Select Apps"){return}
    if($script:AppNamesBuilding){
        if(-not $this.Checked){$script:AppNamesCancel=$true;Set-Status (T "st_cancelling_appnames") "Blue";$form.Refresh();[System.Windows.Forms.Application]::DoEvents()}
        return
    }
    if($this.Checked){
        $answer=[System.Windows.Forms.MessageBox]::Show($form,(T "msg_appnames_confirm_body"),(T "dlg_appnames_title"),[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
        if($answer -ne [System.Windows.Forms.DialogResult]::Yes){
            $script:AppCategoryChanging=$true;try{$this.Checked=$false}finally{$script:AppCategoryChanging=$false};return
        }
        $script:AppNamesBuilding=$true;$script:AppNamesCancel=$false
        try{Build-AppNameCache $script:AppPackages}catch{Add-Log "$(T 'msg_appname_scan_failed'): $_" "Red" -Level Error}
        finally{$script:AppNamesBuilding=$false}
        if(-not $this.Checked -or $script:AppNamesCancel){Set-Status (T "msg_appname_scan_cancelled") "Yellow"}
        elseif($script:AppNamesBuilding -eq $false){$script:SkipAppNameBuildOnce=($script:AppCategory -eq "Filtered")}
    }
    if(-not $script:AppNamesBuilding){Refresh-AppList}
})
$form.Controls.Add($appNamesBox)
$appNamesBtn=New-Object System.Windows.Forms.Button
$appNamesBtn.Text="A";$appNamesBtn.UseMnemonic=$false;$appNamesBtn.Font=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold);$appNamesBtn.Size=New-Object System.Drawing.Size(26,26);$appNamesBtn.Margin=New-Object System.Windows.Forms.Padding(0);$appNamesBtn.FlatStyle="Flat";$appNamesBtn.ForeColor=$clrText;$appNamesBtn.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$appNamesBtn.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(78,78,88);$appNamesBtn.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(78,78,88);$appNamesBtn.Visible=$false;$appNamesBtn.TabStop=$false
$appNamesBtn.Add_Click({$appNamesBox.Checked=-not $appNamesBox.Checked})
$form.Controls.Add($appNamesBtn)
$appResetBtn=New-Object System.Windows.Forms.Button
$appResetBtn.Text="R";$appResetBtn.UseMnemonic=$false;$appResetBtn.Font=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold);$appResetBtn.Size=New-Object System.Drawing.Size(26,26);$appResetBtn.Margin=New-Object System.Windows.Forms.Padding(0);$appResetBtn.FlatStyle="Flat";$appResetBtn.ForeColor=$clrText;$appResetBtn.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$appResetBtn.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(78,78,88);$appResetBtn.Visible=$false;$appResetBtn.TabStop=$false
$appResetBtn.Add_Click({Enter-AndroidFolder $script:AndroidStartPath})
$form.Controls.Add($appResetBtn)
$appNamesBox.Add_CheckedChanged({if($appNamesBtn){if($this.Checked){$appNamesBtn.BackColor=[System.Drawing.Color]::FromArgb(80,150,255);$appNamesBtn.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(110,170,255);$appNamesBtn.ForeColor=[System.Drawing.Color]::White}else{$appNamesBtn.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$appNamesBtn.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(78,78,88);$appNamesBtn.ForeColor=$clrText};$appNamesBtn.Refresh()}})

$logBox=New-Object System.Windows.Forms.ListBox
$logBox.Location="15,550"
$logBox.Size="1020,78"
$logBox.BackColor=[System.Drawing.Color]::FromArgb(18,18,22)
$logBox.ForeColor=$clrDim

#$logBox.Font=New-Object System.Drawing.Font("Consolas",8.5);$logBox.BorderStyle="None";$logBox.TabStop=$false;$logBox.SelectionMode="MultiExtended";$logBox.HideSelection=$false
$logBox.Font=New-Object System.Drawing.Font("Consolas",8.5);$logBox.BorderStyle="None";$logBox.TabStop=$false;$logBox.SelectionMode="MultiExtended"
$form.Controls.Add($logBox)
$script:AppCategoryChanging=$true
$appCatBox.SelectedItem="Select Apps"
$script:AppCategoryChanging=$false

$logBox.Add_MouseDown({
    $script:LogPaused=$true
})

$logBox.Add_KeyDown({
    param($s,$e)

    if($e.Control -and $e.KeyCode -eq [System.Windows.Forms.Keys]::A){
        for($i=0;$i -lt $logBox.Items.Count;$i++){
            $logBox.SetSelected($i,$true)
        }
        $e.SuppressKeyPress=$true
    }
    elseif($e.Control -and $e.KeyCode -eq [System.Windows.Forms.Keys]::C){
        if($logBox.SelectedItems.Count -gt 0){
            try{
                $txt=($logBox.SelectedItems | ForEach-Object {[string]$_}) -join [Environment]::NewLine
                [System.Windows.Forms.Clipboard]::SetText($txt)
            }catch{}
        }
        $e.SuppressKeyPress=$true
    }
})

$logCtx=New-Object System.Windows.Forms.ContextMenuStrip
$logCtx.ShowImageMargin=$false

$miLC=New-Object System.Windows.Forms.ToolStripMenuItem("Copy line")
$miLC.Add_Click({
    if($logBox.SelectedItem){
        try{
            [System.Windows.Forms.Clipboard]::SetText($logBox.SelectedItem.ToString())
        }catch{}
    }
})

$miLA=New-Object System.Windows.Forms.ToolStripMenuItem("Select all")
$miLA.Add_Click({
    for($i=0;$i -lt $logBox.Items.Count;$i++){
        $logBox.SetSelected($i,$true)
    }
})

$miLCA=New-Object System.Windows.Forms.ToolStripMenuItem("Copy all")
$miLCA.Add_Click({
    if($logBox.Items.Count -gt 0){
        try{
            $txt=($logBox.Items | ForEach-Object {[string]$_}) -join [Environment]::NewLine
            [System.Windows.Forms.Clipboard]::SetText($txt)
        }catch{}
    }
})

$miLS=New-Object System.Windows.Forms.ToolStripMenuItem("Scroll to bottom")
$miLS.Add_Click({
    $script:LogPaused=$false
    if($logBox.Items.Count -gt 0){
        $logBox.TopIndex=$logBox.Items.Count-1
    }
})

$miLX=New-Object System.Windows.Forms.ToolStripMenuItem("Clear log")
$miLX.Add_Click({
    $logBox.Items.Clear()
})

$logCtx.Items.AddRange(@(
    $miLC,
    $miLA,
    $miLCA,
    $miLS,
    $miLX
))

$logBox.ContextMenuStrip=$logCtx



$prBg=New-Object System.Windows.Forms.Panel;$prBg.Location="15,632";$prBg.Size="1020,14";$prBg.BackColor=[System.Drawing.Color]::FromArgb(20,20,24);$prBg.Visible=$false
$prFl=New-Object System.Windows.Forms.Panel;$prFl.Location="0,0";$prFl.Size="0,14";$prFl.BackColor=[System.Drawing.Color]::FromArgb(42,118,198)
$prBg.Controls.Add($prFl);$form.Controls.Add($prBg)
function Anim-Bar{param([int]$p,[int]$d)
    $bw=[int]($prBg.Width*0.18);$np=[int]($p+$d*22)
    if(([int]$np+[int]$bw) -ge [int]$prBg.Width){$np=[int]($prBg.Width-$bw);$d=-1}
    if($np -le 0){$np=0;$d=1}
    $prFl.Width=[int]$bw;$prFl.Location=New-Object System.Drawing.Point([int]$np,0)
    return @([int]$np,[int]$d)}
function Request-Stop{
    $script:StopRequested=$true
    if($script:CurrentProc -and -not $script:CurrentProc.HasExited){try{$script:CurrentProc.Kill()}catch{}}
    Set-Status (T "st_cancelling") "Yellow"}

$mkBtn={param([string]$t2,[int]$x2,[int]$y2,[int]$w2=95)
    $b=New-Object System.Windows.Forms.Button;$b.Text=$t2
    $b.Location=New-Object System.Drawing.Point($x2,$y2);$b.Size=New-Object System.Drawing.Size($w2,30)
    $b.FlatStyle="Flat";$b.ForeColor=$clrText;$b.TabStop=$false
    $b.BackColor=[System.Drawing.Color]::FromArgb(48,48,56);$b.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80)
    $form.Controls.Add($b);return $b}
$bY=654
$btnF2=&$mkBtn (T "btn_f2") 15 $bY;$btnF2.Add_Click({Rename-Action})
$btnF3=&$mkBtn (T "btn_f3") 118 $bY;$btnF3.Add_Click({Search-Action})
$btnF4=&$mkBtn (T "btn_f4") 221 $bY;$btnF4.Add_Click({Edit-Action})
$btnF5=&$mkBtn (T "btn_f5") 324 $bY;$btnF5.Add_Click({Copy-Action})
$btnF6=&$mkBtn (T "btn_f6") 427 $bY;$btnF6.Add_Click({Move-Action})
$btnF7=&$mkBtn (T "btn_f7") 530 $bY;$btnF7.Add_Click({NewDir-Action})
$btnF8=&$mkBtn (T "btn_f8") 633 $bY;$btnF8.ForeColor=[System.Drawing.Color]::FromArgb(220,100,90);$btnF8.Add_Click({Delete-Action})
$btnDt=&$mkBtn (T "btn_f9") 736 $bY;$btnDt.Add_Click({Go-Data})
$btnOb=&$mkBtn (T "btn_f10") 839 $bY 95;$btnOb.Add_Click({Go-Obb})
$btnStop=&$mkBtn (T "btn_stop") 942 $bY 70;$btnStop.ForeColor=[System.Drawing.Color]::FromArgb(220,100,90)
$btnStop.Font=New-Object System.Drawing.Font($btnStop.Font,[System.Drawing.FontStyle]::Bold)
$btnStop.Add_Click({Request-Stop})
$btnHp=&$mkBtn (T "btn_help") 1017 $bY 30;$btnHp.ForeColor=$clrGold;$btnHp.Add_Click({Show-Help})

function Do-Resize{
    $W=[int]$form.ClientSize.Width;$H=[int]$form.ClientSize.Height
    $half=[int](($W-30)/2);$lvH=[int]($H-300);if($lvH -lt 80){$lvH=80}
    $aX=[int]($half+20);$szW=80;$dtW=130;$nW=[int]($half-$szW-$dtW);if($nW -lt 80){$nW=80};$dtW=[int]($half-$nW-$szW)
    $lvPC.SetBounds(15,56,$half,$lvH);$hdrPC.SetBounds(15,32,$half,24)
    $hdrPC.Controls[0].SetBounds(0,0,$nW,24);$hdrPC.Controls[1].SetBounds($nW,0,$szW,24);$hdrPC.Controls[2].SetBounds([int]($nW+$szW),0,$dtW,24)
    $lvPC.Columns[0].Width=$nW;$lvPC.Columns[1].Width=$szW;$lvPC.Columns[2].Width=$dtW
    $lblPC.Width=[int]($half-48);$lblPCn.Location=New-Object System.Drawing.Point([int]($half-32),8)
    $lvADB.SetBounds($aX,56,$half,$lvH);$hdrADB.SetBounds($aX,32,$half,24)
    $hdrADB.Controls[0].SetBounds(0,0,$nW,24);$hdrADB.Controls[1].SetBounds($nW,0,$szW,24);$hdrADB.Controls[2].SetBounds([int]($nW+$szW),0,$dtW,24)
    $lvADB.Columns[0].Width=$nW;$lvADB.Columns[1].Width=$szW;$lvADB.Columns[2].Width=$dtW
    $lblADB.SetBounds($aX,8,[int]($half-68),20);$lblADBn.Location=New-Object System.Drawing.Point([int]($W-68),8)
$stY=[int]($lvH+68);$appCatX=[int]($W-175);$appToggleX=[int]($appCatX-4-26);$resetX=[int]($appToggleX-1-26);$filterLabelW=52;$filterModeW=33;$filterGap=0;$filterX=[int]$aX;$filterPhrasesW=[int]($resetX-$filterX-$filterLabelW-$filterModeW-($filterGap*2)-3);if($filterPhrasesW -lt 80){$filterPhrasesW=80};$appFilterStatus.SetBounds($filterX,[int]$stY,$filterLabelW,20);$appFilterModeStatus.SetBounds([int]($filterX+$filterLabelW+$filterGap),[int]$stY,$filterModeW,20);$appFilterPhrasesStatus.SetBounds([int]($filterX+$filterLabelW+$filterGap+$filterModeW+4),[int]$stY,$filterPhrasesW,20);$appNamesBox.SetBounds(-100,-100,1,1);$appNamesBtn.SetBounds($appToggleX,[int]($stY-8),26,26);$appResetBtn.SetBounds($resetX,[int]($stY-8),26,26);$appCatBox.SetBounds($appCatX,[int]($stY-8),160,18);$stBar.SetBounds(15,$stY,[int]($W-30),20);$logBox.SetBounds(15,[int]($stY+22),[int]($W-30),78);$appFilterStatus.BringToFront();$appFilterModeStatus.BringToFront();$appFilterPhrasesStatus.BringToFront();$appNamesBtn.BringToFront();$appResetBtn.BringToFront();$appCatBox.BringToFront()
    $prBg.SetBounds(15,[int]($stY+102),[int]($W-30),14)
    $bY2=[int]($stY+120)
    $btnF2.SetBounds(15,$bY2,95,30);$btnF3.SetBounds(118,$bY2,95,30);$btnF4.SetBounds(221,$bY2,95,30)
    $btnF5.SetBounds(324,$bY2,95,30);$btnF6.SetBounds(427,$bY2,95,30);$btnF7.SetBounds(530,$bY2,95,30)
    $btnF8.SetBounds(633,$bY2,95,30);$btnDt.SetBounds(736,$bY2,95,30)
    $btnHp.SetBounds([int]($W-15-30),$bY2,30,30)
    # F10 keeps the standard fixed width (like F2-F9). STOP now takes the space between
    # F10 and Help (with standard 8px gaps on both sides), computed dynamically so it can
    # never overlap either neighbor regardless of window/DPI metrics.
    $btnOb.SetBounds(839,$bY2,95,30)
    $stopLeft=839+95+8
    $hpLeft=[int]($W-15-30)
    $stopW=[int]($hpLeft-8-$stopLeft)
    if($stopW -lt 45){$stopW=45}
    if($stopW -gt 95){$stopW=95}
    $btnStop.SetBounds($stopLeft,$bY2,$stopW,30)}
$form.Add_Resize({Do-Resize})

function New-AdbProcess{param([string]$args2)
    $psi=New-Object System.Diagnostics.ProcessStartInfo;$psi.FileName=$envAdb;$psi.Arguments=$args2
    $psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true;$psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
    $psi.StandardOutputEncoding=[System.Text.Encoding]::UTF8;$psi.StandardErrorEncoding=[System.Text.Encoding]::UTF8
    $proc=New-Object System.Diagnostics.Process;$proc.StartInfo=$psi;return $proc}
function Invoke-Push{param([string]$LP,[string]$RP,[string]$Lbl,[long]$Sz)
    $adbArgs="push `"$LP`" `"$RP`""
    $proc=New-AdbProcess $adbArgs;$script:CurrentProc=$proc;[void]$proc.Start()
    $tO=$proc.StandardOutput.ReadToEndAsync();$tE=$proc.StandardError.ReadToEndAsync()
    $prBg.Visible=$true;$prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=0
    $sw=[System.Diagnostics.Stopwatch]::StartNew();$p=0;$d=1
    while((-not $proc.HasExited) -and (-not $script:StopRequested)){
        $szS=if($Sz -gt 0){"  $(Format-Bytes $Sz)"}else{""}
        Set-Status "$(T 'st_pushing'): $Lbl$szS  [$([int]$sw.Elapsed.TotalSeconds)s]"
        $r=Anim-Bar $p $d;$p=[int]$r[0];$d=[int]$r[1]
        [System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 80}
    $script:CurrentProc=$null
    if($script:StopRequested){
        try{if(-not $proc.HasExited){$proc.Kill()}}catch{}
        $prBg.Visible=$false;$prFl.Width=0
        Add-Log (T "st_cancelled_op" @($Lbl)) "Yellow";return}
    $out=$tO.Result+$tE.Result;$sp="";$ti=""
    if($out -match "([\d.]+)\s*MB/s"){$sp="  @ $($Matches[1]) MB/s"}
    if($out -match "in\s+([\d.]+)s"){$ti="  in $($Matches[1])s"}
    $prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=[int]$prBg.Width
    Add-Log "$(T 'st_done_push'): $Lbl$ti$sp" "Green";$form.Update();Start-Sleep -Milliseconds 300;$prBg.Visible=$false;$prFl.Width=0}
function Invoke-Pull{param([string]$RP,[string]$LDir,[string]$Lbl,[long]$Sz)
    # Note: adb pull does not give us a reliable live byte count to poll (destination file size
    # can lag or jump), so - like Extracting - this uses a bouncing progress bar + elapsed time
    # instead of a percentage, which was previously stuck showing 0%.
    $adbArgs="pull `"$RP`" `"$LDir`""
    $proc=New-AdbProcess $adbArgs;$script:CurrentProc=$proc;[void]$proc.Start()
    $tO=$proc.StandardOutput.ReadToEndAsync();$tE=$proc.StandardError.ReadToEndAsync()
    $prBg.Visible=$true;$prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=0
    $sw=[System.Diagnostics.Stopwatch]::StartNew();$p=0;$d=1
    while((-not $proc.HasExited) -and (-not $script:StopRequested)){
        $szS=if($Sz -gt 0){"  $(Format-Bytes $Sz)"}else{""}
        Set-Status "$(T 'st_pulling'): $Lbl$szS  [$([int]$sw.Elapsed.TotalSeconds)s]"
        $r=Anim-Bar $p $d;$p=[int]$r[0];$d=[int]$r[1]
        [System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 80}
    $script:CurrentProc=$null
    if($script:StopRequested){
        try{if(-not $proc.HasExited){$proc.Kill()}}catch{}
        $prBg.Visible=$false;$prFl.Width=0
        Add-Log (T "st_cancelled_op" @($Lbl)) "Yellow";return}
    $out=$tO.Result+$tE.Result;$sp="";$ti=""
    if($out -match "([\d.]+)\s*MB/s"){$sp="  @ $($Matches[1]) MB/s"}
    if($out -match "in\s+([\d.]+)s"){$ti="  in $($Matches[1])s"}
    $prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=[int]$prBg.Width
    Add-Log "$(T 'st_done_pull'): $Lbl$ti$sp" "Green";$form.Update();Start-Sleep -Milliseconds 300;$prBg.Visible=$false;$prFl.Width=0}
function Install-APK{param([string]$apkPath)
    $apkN=Split-Path $apkPath -Leaf;$pkg=$null
    if(Test-Path $envAapt2){Set-Status "Reading package info..." "Blue";$pkg=Get-AaptPkg $apkPath}
    $obbDir=$null

#    if($pkg){$cand=Join-Path(Split-Path $apkPath -Parent) $pkg;if(Test-Path $cand -PathType Container){$obbDir=$cand}}
$cand=Join-Path (Split-Path $apkPath -Parent) $pkg
if(Test-Path -LiteralPath $cand -PathType Container){$obbDir=$cand}

    # Custom APK confirm dialog with colored labels
    $apkD=New-Object System.Windows.Forms.Form
    $apkD.Text=(T "dlg_install_apk_title");$apkD.Size="480,250";$apkD.BackColor=$bgForm;$apkD.ForeColor=$clrText
    $apkD.FormBorderStyle="FixedDialog";$apkD.StartPosition="CenterParent";$apkD.KeyPreview=$true
    $apkRtb=New-Object System.Windows.Forms.RichTextBox
    $apkRtb.Location="20,15";$apkRtb.Size="430,130"
    $apkRtb.BackColor=$bgForm;$apkRtb.ForeColor=$clrText;$apkRtb.BorderStyle="None";$apkRtb.ReadOnly=$true
    $apkRtb.Font=New-Object System.Drawing.Font("Segoe UI",10)
    $apkRtb.SelectionColor=$clrText;$apkRtb.AppendText("$(T 'dlg_install_apk_body')`r`n`r`n")
    $apkRtb.SelectionColor=$clrDim;$apkRtb.AppendText("  $(T 'lbl_file'):     ")
    $apkRtb.SelectionColor=$markClr;$apkRtb.AppendText("$apkN`r`n")
    $apkRtb.SelectionColor=$clrDim;$apkRtb.AppendText("  $(T 'lbl_package'):  ")
    if($pkg){$apkRtb.SelectionColor=$markClr;$apkRtb.AppendText("$pkg`r`n")}
    else{$apkRtb.SelectionColor=[System.Drawing.Color]::FromArgb(120,118,112);$apkRtb.AppendText("$(T 'msg_aapt2_not_found')`r`n")}
    if($obbDir){
        $apkRtb.SelectionColor=$clrDim;$apkRtb.AppendText("  $(T 'lbl_obb'):      ")
        $apkRtb.SelectionColor=[System.Drawing.Color]::FromArgb(100,200,100);$apkRtb.AppendText("$(T 'msg_obb_found')`r`n")}
    $apkD.Controls.Add($apkRtb)
    $apkOk=New-Object System.Windows.Forms.Button;$apkOk.Text=(T "btn_ok");$apkOk.Size="90,30";$apkOk.FlatStyle="Flat"
    $apkCn=New-Object System.Windows.Forms.Button;$apkCn.Text=(T "btn_cancel");$apkCn.Size="90,30";$apkCn.FlatStyle="Flat"
    foreach($bx in @($apkOk,$apkCn)){$bx.ForeColor=$clrText;$bx.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$bx.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80)}
    $apkOk.Location=New-Object System.Drawing.Point(130,162);$apkCn.Location=New-Object System.Drawing.Point(240,162)
    $apkOk.DialogResult="OK";$apkCn.DialogResult="Cancel"
    $apkD.Controls.AddRange(@($apkOk,$apkCn));$apkD.AcceptButton=$apkOk;$apkD.CancelButton=$apkCn
    $apkD.Add_Shown({$apkOk.Focus()})
    if($apkD.ShowDialog() -ne "OK"){return}
    $prBg.Visible=$true;$prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=0
    $sw=[System.Diagnostics.Stopwatch]::StartNew();$p=0;$d=1
    $adbArgs="install -r -g `"$apkPath`""
    $script:StopRequested=$false
    $proc=New-AdbProcess $adbArgs;$script:CurrentProc=$proc;[void]$proc.Start()
    $tO=$proc.StandardOutput.ReadToEndAsync();$tE=$proc.StandardError.ReadToEndAsync()
    while((-not $proc.HasExited) -and (-not $script:StopRequested)){Set-Status "$(T 'st_installing'): $apkN  [$([int]$sw.Elapsed.TotalSeconds)s]";$r=Anim-Bar $p $d;$p=[int]$r[0];$d=[int]$r[1];[System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 80}
    $script:CurrentProc=$null
    if($script:StopRequested){try{if(-not $proc.HasExited){$proc.Kill()}}catch{};$prFl.Width=0;$prBg.Visible=$false;Add-Log (T "st_cancelled_op" @($apkN)) "Yellow";$script:StopRequested=$false;return}
    $out=($tO.Result+$tE.Result) -replace "
","" -replace "
"," "
    $prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=0;$prBg.Visible=$false
    if($out -match "Success"){Add-Log "$(T 'st_installed'): $apkN  [$([int]$sw.Elapsed.TotalSeconds)s]" "Green"}
    else{$err=$out;if($out -match "(INSTALL_\w+)"){$err=$Matches[1]};Add-Log "$(T 'st_install_failed'): $err" "Red";return}
    if($obbDir){$base="/storage/emulated/0/Android/obb";& "$envAdb" shell "mkdir -p '$base/$pkg'" 2>&1 | Out-Null

#        $fs=Get-ChildItem $obbDir -File;$ix=0
$fs=@(Get-ChildItem -LiteralPath $obbDir -File);$ix=0

        foreach($f in $fs){
            $ix++;Set-Status "$(T 'st_obb') ($ix/$($fs.Count)): $($f.Name)...";Invoke-Push $f.FullName "$base/$pkg/$($f.Name)" $f.Name $f.Length
            if($script:StopRequested){break}}
        if($script:StopRequested){Add-Log (T "log_paste_cancelled") "Yellow";$script:StopRequested=$false}
        else{Add-Log (T "st_done_apk_obb" @($fs.Count)) "Green"}}
    Refresh-Panel "ADB"}

function Install-XAPK{param([string]$xapkPath)
    if(-not(Test-Path $env7z -ErrorAction SilentlyContinue)){Add-Log (T "msg_7z_not_found") "Red";return}
    $xapkN=Split-Path $xapkPath -Leaf
    $tmpX=New-TmpDir
    try{
        Set-Status "$(T 'st_extracting_xapk')..." "Blue"
        $psiX=New-Object System.Diagnostics.ProcessStartInfo
        $psiX.FileName=$env7z;$psiX.Arguments="x `"$xapkPath`" -o`"$tmpX`" -aoa -y"
        $psiX.UseShellExecute=$false;$psiX.CreateNoWindow=$true
        $psiX.RedirectStandardOutput=$true;$psiX.RedirectStandardError=$true
        $procX=New-Object System.Diagnostics.Process;$procX.StartInfo=$psiX
        [void]$procX.Start();$procX.WaitForExit()
        # Find all APK files inside
        $allApks=@(Get-ChildItem -LiteralPath $tmpX -Filter "*.apk" -Recurse|Sort-Object {
            # base.apk first
            if($_.Name -eq "base.apk"){0}else{1}})
        if($allApks.Count -eq 0){Add-Log (T "msg_xapk_no_apk") "Red";return}
        $baseApk=$allApks[0]
        $pkg2=$null
        if(Test-Path $envAapt2 -ErrorAction SilentlyContinue){$pkg2=Get-AaptPkg $baseApk.FullName}
        $obbFiles=@(Get-ChildItem -LiteralPath $tmpX -Filter "*.obb" -Recurse)
        $isSplit=($allApks.Count -gt 1)
        # Confirm dialog
        $apkD2=New-Object System.Windows.Forms.Form
        $apkD2.Text=(T "dlg_install_xapk_title");$apkD2.Size="480,220";$apkD2.BackColor=$bgForm;$apkD2.ForeColor=$clrText
        $apkD2.FormBorderStyle="FixedDialog";$apkD2.StartPosition="CenterParent"
        $apkRtb2=New-Object System.Windows.Forms.RichTextBox
        $apkRtb2.Location="20,15";$apkRtb2.Size="430,120"
        $apkRtb2.BackColor=$bgForm;$apkRtb2.ForeColor=$clrText;$apkRtb2.BorderStyle="None";$apkRtb2.ReadOnly=$true
        $apkRtb2.Font=New-Object System.Drawing.Font("Segoe UI",10)
        $apkRtb2.SelectionColor=$clrText;$apkRtb2.AppendText("$(T 'dlg_install_xapk_body')`r`n`r`n")
        $apkRtb2.SelectionColor=$clrDim;$apkRtb2.AppendText("  $(T 'lbl_file'):     ")
        $apkRtb2.SelectionColor=$markClr;$apkRtb2.AppendText("$xapkN`r`n")
        if($pkg2){$apkRtb2.SelectionColor=$clrDim;$apkRtb2.AppendText("  $(T 'lbl_package'):  ");$apkRtb2.SelectionColor=$markClr;$apkRtb2.AppendText("$pkg2`r`n")}
        if($isSplit){$apkRtb2.SelectionColor=$clrDim;$apkRtb2.AppendText("  $(T 'lbl_type'):     ");$apkRtb2.SelectionColor=[System.Drawing.Color]::FromArgb(100,200,100);$apkRtb2.AppendText((T "msg_split_apks" @($allApks.Count))+"`r`n")}
        elseif($obbFiles.Count -gt 0){$apkRtb2.SelectionColor=$clrDim;$apkRtb2.AppendText("  $(T 'lbl_obb'):      ");$apkRtb2.SelectionColor=[System.Drawing.Color]::FromArgb(100,200,100);$apkRtb2.AppendText((T "msg_files_will_be_copied" @($obbFiles.Count))+"`r`n")}
        $apkD2.Controls.Add($apkRtb2)
        $apkOk2=New-Object System.Windows.Forms.Button;$apkOk2.Text=(T "btn_ok");$apkOk2.Size="90,30";$apkOk2.FlatStyle="Flat"
        $apkCn2=New-Object System.Windows.Forms.Button;$apkCn2.Text=(T "btn_cancel");$apkCn2.Size="90,30";$apkCn2.FlatStyle="Flat"
        foreach($bx2 in @($apkOk2,$apkCn2)){$bx2.ForeColor=$clrText;$bx2.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$bx2.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80)}
        $apkOk2.DialogResult="OK";$apkCn2.DialogResult="Cancel"
        $apkOk2.Location=New-Object System.Drawing.Point(130,158);$apkCn2.Location=New-Object System.Drawing.Point(240,158)
        $apkD2.Controls.AddRange(@($apkOk2,$apkCn2));$apkD2.AcceptButton=$apkOk2;$apkD2.CancelButton=$apkCn2
        $apkD2.Add_Shown({$apkOk2.Focus()})
        if($apkD2.ShowDialog() -ne "OK"){return}
        # Install
        $sw2=[System.Diagnostics.Stopwatch]::StartNew()
        $script:StopRequested=$false
        if($isSplit){
            # Split XAPK: use install-multiple with all APK parts
            $allApkPaths=($allApks|ForEach-Object{"`"$($_.FullName)`""}) -join " "
            $adbArgsX2="install-multiple -r -g $allApkPaths"
            $procI=New-AdbProcess $adbArgsX2;$script:CurrentProc=$procI;[void]$procI.Start()
            $tOX=$procI.StandardOutput.ReadToEndAsync();$tEX=$procI.StandardError.ReadToEndAsync()
            while((-not $procI.HasExited) -and (-not $script:StopRequested)){Set-Status "$(T 'st_installing_xapk_split')... [$([int]$sw2.Elapsed.TotalSeconds)s]";[System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 100} "Blue"
            $outX=($tOX.Result+$tEX.Result).Trim()
        }else{
            # OBB XAPK: install base.apk only
            $adbArgsX="install -r -g `"$($baseApk.FullName)`""
            $procI=New-AdbProcess $adbArgsX;$script:CurrentProc=$procI;[void]$procI.Start()
            $tOX=$procI.StandardOutput.ReadToEndAsync();$tEX=$procI.StandardError.ReadToEndAsync()
            while((-not $procI.HasExited) -and (-not $script:StopRequested)){Set-Status "$(T 'st_installing_xapk')... [$([int]$sw2.Elapsed.TotalSeconds)s]";[System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 100} "Blue"
            $outX=($tOX.Result+$tEX.Result).Trim()
        }
        $script:CurrentProc=$null
        if($script:StopRequested){try{if(-not $procI.HasExited){$procI.Kill()}}catch{};Add-Log (T "st_cancelled_op" @($xapkN)) "Yellow";$script:StopRequested=$false;return}
        if($outX -match "Success"){
            Add-Log "$(T 'st_installed_xapk'): $xapkN  [$([int]$sw2.Elapsed.TotalSeconds)s]" "Green"
            # Copy OBB files if present
            if($obbFiles.Count -gt 0 -and $pkg2){
                $obbBase="/storage/emulated/0/Android/obb/$pkg2"
                & "$envAdb" shell "mkdir -p $(Escape-AdbShell $obbBase)" 2>&1|Out-Null
                $oix=0
                foreach($of in $obbFiles){
                    $oix++;Set-Status "$(T 'st_obb') ($oix/$($obbFiles.Count)): $($of.Name)" "Blue"
                    Invoke-Push $of.FullName "$obbBase/$($of.Name)" $of.Name $of.Length
                    if($script:StopRequested){break}}
                if($script:StopRequested){Add-Log (T "log_paste_cancelled") "Yellow";$script:StopRequested=$false}
                else{Add-Log (T "st_obb_copied" @($obbFiles.Count)) "Green"}}
        }else{Add-Log "$(T 'st_xapk_install_failed'): $outX" "Red"}
    }finally{Remove-Item -LiteralPath $tmpX -Recurse -Force -ErrorAction SilentlyContinue}
    Refresh-Panel "ADB"}

function Install-APKS{param([string]$apksPath)
    # APKS = ZIP with multiple split APKs (from bundletool/SAI)
    if(-not(Test-Path $env7z -ErrorAction SilentlyContinue)){
        Add-Log (T "msg_7z_not_found_apks") "Red";return}
    $apksN=Split-Path $apksPath -Leaf
    $tmpA=New-TmpDir
    try{
        Set-Status "$(T 'st_extracting_apks')..." "Blue"
        $psiA=New-Object System.Diagnostics.ProcessStartInfo
        $psiA.FileName=$env7z;$psiA.Arguments="x `"$apksPath`" -o`"$tmpA`" -aoa -y *.apk"
        $psiA.UseShellExecute=$false;$psiA.CreateNoWindow=$true
        $psiA.RedirectStandardOutput=$true;$psiA.RedirectStandardError=$true
        $procA=New-Object System.Diagnostics.Process;$procA.StartInfo=$psiA
        [void]$procA.Start();$procA.WaitForExit()
        $apkFiles=@(Get-ChildItem -LiteralPath $tmpA -Filter "*.apk" -Recurse)
        if($apkFiles.Count -eq 0){Add-Log (T "msg_apks_no_apk") "Red";return}
        # Confirm dialog
        $apkD3=New-Object System.Windows.Forms.Form
        $apkD3.Text=(T "dlg_install_apks_title");$apkD3.Size="480,200";$apkD3.BackColor=$bgForm;$apkD3.ForeColor=$clrText
        $apkD3.FormBorderStyle="FixedDialog";$apkD3.StartPosition="CenterParent"
        $apkRtb3=New-Object System.Windows.Forms.RichTextBox
        $apkRtb3.Location="20,15";$apkRtb3.Size="430,100"
        $apkRtb3.BackColor=$bgForm;$apkRtb3.ForeColor=$clrText;$apkRtb3.BorderStyle="None";$apkRtb3.ReadOnly=$true
        $apkRtb3.Font=New-Object System.Drawing.Font("Segoe UI",10)
        $apkRtb3.SelectionColor=$clrText;$apkRtb3.AppendText("$(T 'dlg_install_apks_body')`r`n`r`n")
        $apkRtb3.SelectionColor=$clrDim;$apkRtb3.AppendText("  $(T 'lbl_file'):     ")
        $apkRtb3.SelectionColor=$markClr;$apkRtb3.AppendText("$apksN`r`n")
        $apkRtb3.SelectionColor=$clrDim;$apkRtb3.AppendText("  $(T 'lbl_splits'):   ")
        $apkRtb3.SelectionColor=$markClr;$apkRtb3.AppendText((T "msg_apk_files_count" @($apkFiles.Count))+"`r`n")
        $apkD3.Controls.Add($apkRtb3)
        $apkOk3=New-Object System.Windows.Forms.Button;$apkOk3.Text=(T "btn_ok");$apkOk3.Size="90,30";$apkOk3.FlatStyle="Flat"
        $apkCn3=New-Object System.Windows.Forms.Button;$apkCn3.Text=(T "btn_cancel");$apkCn3.Size="90,30";$apkCn3.FlatStyle="Flat"
        foreach($bx3 in @($apkOk3,$apkCn3)){$bx3.ForeColor=$clrText;$bx3.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$bx3.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80)}
        $apkOk3.Location=New-Object System.Drawing.Point(130,135);$apkCn3.Location=New-Object System.Drawing.Point(240,135)
        $apkOk3.DialogResult="OK";$apkCn3.DialogResult="Cancel"
        $apkD3.Controls.AddRange(@($apkOk3,$apkCn3));$apkD3.AcceptButton=$apkOk3;$apkD3.CancelButton=$apkCn3
        $apkD3.Add_Shown({$apkOk3.Focus()})
        if($apkD3.ShowDialog() -ne "OK"){return}
        # Install all splits with install-multiple
        $allApkPaths=($apkFiles|ForEach-Object{"`"$($_.FullName)`""}) -join " "
        $adbArgsA="install-multiple -r -g $allApkPaths"
        $script:StopRequested=$false
        $procM=New-AdbProcess $adbArgsA;$script:CurrentProc=$procM;[void]$procM.Start()
        $tOM=$procM.StandardOutput.ReadToEndAsync();$tEM=$procM.StandardError.ReadToEndAsync()
        $sw3=[System.Diagnostics.Stopwatch]::StartNew()
        while((-not $procM.HasExited) -and (-not $script:StopRequested)){
            Set-Status "$(T 'st_installing_apks')... [$([int]$sw3.Elapsed.TotalSeconds)s]" "Blue"
            [System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 100}
        $script:CurrentProc=$null
        if($script:StopRequested){try{if(-not $procM.HasExited){$procM.Kill()}}catch{};Add-Log (T "st_cancelled_op" @($apksN)) "Yellow";$script:StopRequested=$false;return}
        $outA=($tOM.Result+$tEM.Result) -replace "`r`n"," "
        if($outA -match "Success"){Add-Log "$(T 'st_installed_apks'): $apksN  [$([int]$sw3.Elapsed.TotalSeconds)s]" "Green"}
        else{Add-Log "$(T 'st_apks_install_failed'): $outA" "Red"}
    }finally{Remove-Item -LiteralPath $tmpA -Recurse -Force -ErrorAction SilentlyContinue}
    Refresh-Panel "ADB"}

function Open-File{param([string]$fp,[string]$act)
    $leaf=Split-Path $fp -Leaf;$dot=$leaf.LastIndexOf(".")
    $ext=if($dot -ge 0){$leaf.Substring($dot+1).ToLower()}else{""};$ft=Get-FileType $leaf
    switch($act){"run"{switch($ext){"ps1"{Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$fp`""}"bat"{Start-Process cmd -ArgumentList "/c `"$fp`""}"cmd"{Start-Process cmd -ArgumentList "/c `"$fp`""} default{Start-Process $fp}}}
        "edit"{if($ft -eq "text" -or $ext -in @("ps1","bat","cmd","sh","bash")){Show-TextEditor $fp $leaf}
               else{$r=Show-AdbDialog (T "dlg_not_text_file") (T "dlg_open_in_editor_anyway") $null @($leaf);if($null -ne $r){Show-TextEditor $fp $leaf}}}
        "open"{Start-Process $fp}}}
function Edit-AdbFile{param([string]$rp,[string]$fn)
    $tmp=Join-Path $env:TEMP "adbfm_$fn";Set-Status "$(T 'st_pulling_file') $fn..."
    & "$envAdb" pull "`"$rp`"" "`"$tmp`"" 2>&1 | Out-Null
    if(-not(Test-Path $tmp)){Add-Log "$(T 'st_pull_failed'): $fn" "Red";return}
    $ft=Get-FileType $fn;$dot=$fn.LastIndexOf(".")
    $ext=if($dot -ge 0){$fn.Substring($dot+1).ToLower()}else{""}
    if($ft -ne "text" -and $ext -notin @("ps1","bat","cmd","sh","bash")){$r=Show-AdbDialog (T "dlg_not_text_file") (T "dlg_open_anyway") $null @($fn);if($null -eq $r){return}}
    Show-TextEditor $tmp "$fn [Android]" $true $rp
    Set-Status (T "st_ready") "Green"}
function Make-LVI{param([string]$disp,[string]$szDisp,[long]$szBytes,[string]$dt,[string]$fullPath,[bool]$isDir=$false)
    $li=New-Object System.Windows.Forms.ListViewItem($disp)
    $li.SubItems.Add($szDisp)|Out-Null;$li.SubItems.Add($dt)|Out-Null;$li.SubItems.Add([string]$szBytes)|Out-Null
    $li.Tag=if($isDir){"DIR:$fullPath"}else{"FILE:$fullPath"};return $li}
function Get-ItemTag{param($item)
    if($null -eq $item){return @{IsDir=$false;Path=""}}
    $t=[string]$item.Tag
    if($t -eq "__GOUP__"){return @{IsDir=$false;Path="__GOUP__"}}
    if($t -eq "__ARCHCLOSE__"){return @{IsDir=$false;Path="__ARCHCLOSE__"}}
    if($t.StartsWith("ARCH:")){return @{IsDir=$false;Path=$t}}  # keep ARCH: prefix for archive items
    if($t.StartsWith("DIR:")){return @{IsDir=$true;Path=$t.Substring(4)}}
    if($t.StartsWith("FILE:")){return @{IsDir=$false;Path=$t.Substring(5)}}
    if($t.StartsWith("APP:")){return @{IsDir=$false;Path=$t.Substring(4)}}
    return @{IsDir=$false;Path=$t}}
function Sort-LVI{param($arr,[string]$col,[bool]$asc)
    if($arr.Count -eq 0){return $arr}
    $s=switch($col){"Size"{$arr|Sort-Object{[long]$_.SubItems[3].Text}}"Date"{$arr|Sort-Object{$_.SubItems[2].Text}}default{$arr|Sort-Object{$_.Text}}}
    if(-not $asc){[array]::Reverse($s)};return $s}
function Refresh-Panel{param([string]$panel)
    if($panel -eq "PC"){
        $lv=$lvPC;$lv.BeginUpdate();$lv.Items.Clear();$lblPC.Text=$currentLocalPath
        $dirs=@();$files=@()
        if($currentLocalPath -eq "DRIVES"){[System.IO.DriveInfo]::GetDrives()|Where-Object{$_.IsReady}|ForEach-Object{$dirs+=Make-LVI $_.Name "<Dir>" 0 "" $_.Name $true}}
        else{
            $goUp=New-Object System.Windows.Forms.ListViewItem(".. [Go Up]")
            $goUp.SubItems.Add("")|Out-Null;$goUp.SubItems.Add("")|Out-Null;$goUp.SubItems.Add("0")|Out-Null;$goUp.Tag="__GOUP__";$lv.Items.Add($goUp)|Out-Null
            Get-ChildItem -LiteralPath $currentLocalPath -ErrorAction SilentlyContinue|ForEach-Object{
                if($_.PSIsContainer){$dirs+=Make-LVI $_.Name "<Dir>" 0 ($_.LastWriteTime.ToString("yyyy-MM-dd HH:mm")) (Join-Path $currentLocalPath $_.Name) $true}
                else{$sz=[long]$_.Length;$files+=Make-LVI $_.Name (Format-Bytes $sz) $sz ($_.LastWriteTime.ToString("yyyy-MM-dd HH:mm")) (Join-Path $currentLocalPath $_.Name) $false}}}
        $dirs=Sort-LVI $dirs $global:SortPC $global:SortPCAsc;$files=Sort-LVI $files $global:SortPC $global:SortPCAsc
        foreach($li in $dirs){$lv.Items.Add($li)|Out-Null};foreach($li in $files){$lv.Items.Add($li)|Out-Null}
        if($lv.Items.Count -gt 0){$lv.Items[0].Selected=$true;$lv.Items[0].Focused=$true};$lv.EndUpdate()
    }else{
        if($script:AppMode){Refresh-AppList;return}
        $lv=$lvADB;$lv.BeginUpdate();$lv.Items.Clear();$lblADB.Text=$currentAdbPath
        if(-not $script:AdbAvailable){$lv.EndUpdate();return}
        $goUp=New-Object System.Windows.Forms.ListViewItem(".. [Go Up]")
        $goUp.SubItems.Add("")|Out-Null;$goUp.SubItems.Add("")|Out-Null;$goUp.SubItems.Add("0")|Out-Null;$goUp.Tag="__GOUP__";$lv.Items.Add($goUp)|Out-Null
        $dirs=@();$files=@()
        $lsOut=& "$envAdb" shell ('ls -F '+(Escape-AdbShell $currentAdbPath)) 2>&1
        foreach($entry in $lsOut){
            $r=($entry -replace "`r","").Trim()
            if(-not $r){continue}
            if($r.StartsWith("* ") -or $r -match "^daemon |^adb "){continue}
            $isD=$r.EndsWith("/")
            $cn=$r -replace "[/*@=>|]$",""
            if(-not $cn){continue}
            $fullP="$($currentAdbPath.TrimEnd("/"))/$cn"
            if($isD){$dirs+=Make-LVI $cn "<Dir>" 0 "" $fullP $true}
            else{$files+=Make-LVI $cn "" 0 "" $fullP $false}
        }
        if($dirs.Count -gt 0 -or $files.Count -gt 0){
            $statOut=& "$envAdb" shell ("stat -c " + [char]39 + "%n|%s|%y" + [char]39 + " " + (Escape-AdbShell ($currentAdbPath.TrimEnd("/")+"/*"))) 2>&1 | Out-Null
            $statMap=@{}
            foreach($line in $statOut){$l=($line -replace "
","").Trim();if(-not $l){continue};if($l.StartsWith("* ") -or $l -match "^daemon |^adb "){continue}
                $p3=$l -split "\|",3;if($p3.Count -ge 3){
                    $fn2=Split-Path $p3[0].Trim() -Leaf;$sz2=0L;try{$sz2=[long]$p3[1].Trim()}catch{}
                    $dt2=$p3[2].Trim();if($dt2.Length -gt 16){$dt2=$dt2.Substring(0,16)};$statMap[$fn2]=@{Sz=$sz2;Dt=$dt2}}}
            foreach($li in $files){$fn2=$li.Text;if($statMap.ContainsKey($fn2)){$li.SubItems[1].Text=Format-Bytes $statMap[$fn2].Sz;$li.SubItems[3].Text=[string]$statMap[$fn2].Sz;$li.SubItems[2].Text=$statMap[$fn2].Dt}}
            foreach($li in $dirs){if($statMap.ContainsKey($li.Text)){$li.SubItems[2].Text=$statMap[$li.Text].Dt}}}
        $dirs=Sort-LVI $dirs $global:SortADB $global:SortADBAsc;$files=Sort-LVI $files $global:SortADB $global:SortADBAsc
        foreach($li in $dirs){$lv.Items.Add($li)|Out-Null};foreach($li in $files){$lv.Items.Add($li)|Out-Null}
        if($lv.Items.Count -gt 0){$lv.Items[0].Selected=$true;$lv.Items[0].Focused=$true};$lv.EndUpdate()}}
function Get-ALV{if($lvPC.Focused -or $lvPC.BackColor -eq $bgActive){return $lvPC};return $lvADB}
function Get-SelI{param($lv);if($lv.SelectedItems.Count -eq 0){return $null};return $lv.SelectedItems[0]}
function Get-SelItems{param($lv)
    $res=@()
    foreach($it in $lv.Items){$ti=Get-ItemTag $it;if($ti.Path -ne "__GOUP__" -and $ti.Path -ne "" -and $global:SelectedPaths.Contains($ti.Path)){$res+=$it}}
    if($res.Count -eq 0){$s=Get-SelI $lv;if($null -ne $s -and $s.Tag -ne "__GOUP__"){$res+=$s}}
    return $res}
function Find-Sel{param($lv,[string]$name)
    foreach($li in $lv.Items){if($li.Text -eq $name){$li.Selected=$true;$li.Focused=$true;$lv.EnsureVisible($li.Index);break}}}


# APPLICATION MANAGER
# The Android panel can be switched to an application list using the category selector.
function Update-AppFilterStatus {
    if($script:AppFilter -and $script:AppFilter.Trim() -ne ""){
        $phrases=if($script:AppFilterPhrases.Count -gt 0){$script:AppFilterPhrases -join ", "}else{$script:AppFilter.Trim()}
        $modeText=if($script:AppFilterMode -eq "All"){"[$(T 'filter_mode_all')]"}else{"[$(T 'filter_mode_any')]"}
        $appFilterStatus.Text="$(T 'lbl_filtered_colon')"
        $appFilterModeStatus.Text=$modeText
        $appFilterPhrasesStatus.Text=$phrases
        $appFilterStatus.Visible=$true;$appFilterModeStatus.Visible=$true;$appFilterPhrasesStatus.Visible=$true
    }else{
        $appFilterStatus.Text="";$appFilterPhrasesStatus.Text="";$appFilterModeStatus.Text=""
        $appFilterStatus.Visible=$false;$appFilterPhrasesStatus.Visible=$false;$appFilterModeStatus.Visible=$false
    }
}
function Get-AppPackages {
    param([string]$category="All")

    if(-not $script:AdbAvailable){ return @() }

    try{
        switch($category){
            "Removed" {
                $all=@(& "$envAdb" shell pm list packages -u 2>&1 | ForEach-Object { ([string]$_).Trim() -replace '^package:', '' } | Where-Object {$_})
                $installed=@(& "$envAdb" shell pm list packages 2>&1 | ForEach-Object { ([string]$_).Trim() -replace '^package:', '' } | Where-Object {$_})
                return @($all | Where-Object {$_ -notin $installed} | Sort-Object -Unique)
            }
            "Update System" {
                # Find installed packages which still have a built-in system APK and
                # also have an updated APK under /data/app/. On some Android builds
                # pm list packages -s no longer returns a package after it is updated,
                # so scan the complete installed package list instead.
                Set-Status (T "st_scanning_system_updates") "Blue"
                $form.Refresh();[System.Windows.Forms.Application]::DoEvents()
                $system=@(& "$envAdb" shell pm list packages 2>&1 | ForEach-Object { ([string]$_).Trim() -replace '^package:', '' } | Where-Object {$_})
                $result=New-Object System.Collections.Generic.List[string]
                $total=$system.Count;$idx=0
                foreach($pkg in $system){
                    $idx++
                    if(($idx % 20) -eq 0){Set-Status (T "st_scanning_system_updates_progress" @($idx,$total)) "Blue";$form.Refresh();[System.Windows.Forms.Application]::DoEvents()}
                    $paths=@(& "$envAdb" shell pm path $pkg 2>&1 | ForEach-Object { ([string]$_).Trim() })
                    $hasSystem=$false;$hasDataApp=$false
                    foreach($line in $paths){
                        $path=$line -replace '^package:',''
                        if($path -match '^/(system|system_ext|product|vendor|odm)/'){$hasSystem=$true}
                        if($path -match '^/data/app/'){$hasDataApp=$true}
                    }
                    if($hasSystem -and $hasDataApp){[void]$result.Add($pkg)}
                }
                Set-Status "Ready" "Green"
                return @($result | Sort-Object -Unique)
            }
        }

        $arg = switch($category){
            "System"      {"-s"}
            "Third-Party" {"-3"}
            "Enabled"     {"-e"}
            "Disabled"    {"-d"}
            default        {""}
        }

        $raw = if($arg -eq ""){
            & "$envAdb" shell pm list packages 2>&1
        }else{
            & "$envAdb" shell pm list packages $arg 2>&1
        }

        $result=@()
        foreach($line in $raw){
            $v=([string]$line).Trim()
            if($v -match '^package:(.+)$'){
                $pkg=$Matches[1].Trim()
                if($pkg -and $pkg -notmatch '\s'){$result += $pkg}
            }
        }
        return @($result | Sort-Object -Unique)
    }catch{
        Add-Log "Failed to retrieve application list: $_" "Red" -Level Error
        return @()
    }
}

function Update-AppNamesStatus {
    if($script:AppNamesBuilding){
        $t=[int]$script:AppNamesTotal;$r=[int]$script:AppNamesRead
        if($t -lt 0){$t=0};if($r -lt 0){$r=0}
        if($r -gt $t){$r=$t}
        Set-Status (T "st_reading_app_names" @($r,$t)) "Blue"
    }
}
function Build-AppNameCache {
    param([string[]]$Packages)
    $list=@($Packages | Where-Object {$_} | Sort-Object -Unique);$total=$list.Count
    $script:AppNamesTotal=$total;$script:AppNamesRead=0;$script:AppNamesCancel=$false
    Set-Status (T "st_reading_app_names" @(0,$total)) "Blue"
    $form.Refresh();[System.Windows.Forms.Application]::DoEvents()
    $usedDevice=$false
    if(Test-Path $envAaptArm -ErrorAction SilentlyContinue){
        $usedDevice=Build-AppNameCacheOnDevice $list
    }else{
        Add-Log (T "msg_aapt_arm_not_found") "Yellow" -Level Important
    }
    if($script:AppNamesCancel){return}
    if(-not $usedDevice){
        if(-not (Test-Path $envAapt2 -ErrorAction SilentlyContinue)){
            Add-Log (T "msg_no_aapt_available") "Red" -Level Error
            $script:AppNamesCancel=$true;return
        }
        $i=0
        foreach($pkg in $list){
            if(-not $appNamesBox.Checked){$script:AppNamesCancel=$true;Set-Status (T "st_cancelling_appnames") "Blue";$form.Refresh();[System.Windows.Forms.Application]::DoEvents();break}
            $i++;[void](Get-AppLabelFromPackage $pkg $true);$script:AppNamesRead=$i
            if(($i % 3)-eq 0 -or $i -eq $total){Update-AppNamesStatus;$form.Refresh();[System.Windows.Forms.Application]::DoEvents()}
        }
    }else{$script:AppNamesRead=$total;Update-AppNamesStatus;$form.Refresh();[System.Windows.Forms.Application]::DoEvents()}
    if($script:AppNamesCancel){Set-Status (T "st_reading_app_names_cancelled" @($script:AppNamesRead,$script:AppNamesTotal)) "Blue"}
    else{$script:AppNamesCompletedUntil=(Get-Date).AddSeconds(3);$script:AppNamesShowCompleted=$true;Set-Status (T "st_reading_completed" @($script:AppNamesRead,$script:AppNamesTotal)) "Blue"}
}
function Ensure-AppNamesForPackages {
    param([string[]]$Packages)
    if(-not $appNamesBox.Checked -or @($Packages).Count -eq 0){return $true}
    $missing=@($Packages|Where-Object{-not $script:AppNameCache.ContainsKey($_)})
    if($missing.Count -eq 0){return $true}
    if(-not $script:AppNamesBuilding -and -not $script:AppNamesPrompted){
        $answer=[System.Windows.Forms.MessageBox]::Show($form,(T "msg_appnames_confirm_body"),(T "dlg_appnames_title"),[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
        if($answer -ne [System.Windows.Forms.DialogResult]::Yes){return $false}
        $script:AppNamesBuilding=$true;$script:AppNamesCancel=$false
        try{Build-AppNameCache $missing}finally{$script:AppNamesBuilding=$false}
    }
    return (-not $script:AppNamesCancel)
}

function Make-AppLVI {
    param([string]$pkg)
    if($appNamesBox -and $appNamesBox.Checked){
        if($script:AppNameCache.ContainsKey($pkg)){$display=[string]$script:AppNameCache[$pkg]}
        else{$display=$pkg}
    }else{$display=$pkg}
    $li=New-Object System.Windows.Forms.ListViewItem($display)
    $li.SubItems.Add("")|Out-Null
    $li.SubItems.Add("")|Out-Null
    $li.Tag="APP:$pkg"
    return $li
}

function Test-AppFilterMatch {
    param([string]$Package,[string[]]$Phrases,[string]$Mode="All")
    if($null -eq $Phrases -or $Phrases.Count -eq 0){return $false}
    if($Mode -eq "All"){
        foreach($phrase in $Phrases){
            if([string]::IsNullOrWhiteSpace($phrase)){continue}
            if($Package.IndexOf($phrase.Trim(),[System.StringComparison]::OrdinalIgnoreCase) -lt 0){return $false}
        }
        return $true
    }
    foreach($phrase in $Phrases){
        if([string]::IsNullOrWhiteSpace($phrase)){continue}
        if($Package.IndexOf($phrase.Trim(),[System.StringComparison]::OrdinalIgnoreCase) -ge 0){return $true}
    }
    return $false
}

function Refresh-AppList {
    if(-not $script:AppMode){return}
    $lv=$lvADB;$lv.BeginUpdate()
    try{
        $lv.Items.Clear()
        $sourceCategory=if($script:AppCategory -eq "Filtered"){$script:AppBaseCategory}else{$script:AppCategory}
        if($sourceCategory -eq "Select Apps"){$sourceCategory="All"}

        # When AppNames is enabled while already displaying Filtered, the name scan
        # was deliberately performed only for the packages currently visible in the
        # filtered list. Do NOT rebuild the source category here: doing so would make
        # us read every application name and could also make the filtered list grow.
        $useCurrentFilteredPackages=($script:AppCategory -eq "Filtered" -and $script:SkipAppNameBuildOnce)
        if($useCurrentFilteredPackages){
            $basePackages=@($script:AppPackages)
        }else{
            $basePackages=@(Get-AppPackages $sourceCategory)
        }

        $displayPackages=$basePackages
        if($appNamesBox -and $appNamesBox.Checked -and $basePackages.Count -gt 0 -and -not $script:SkipAppNameBuildOnce){
            # Build the cache once for this category.
            $missing=@($basePackages | Where-Object {-not $script:AppNameCache.ContainsKey($_)})
            if($missing.Count -gt 0){[void](Ensure-AppNamesForPackages $missing)}
        }
        $script:SkipAppNameBuildOnce=$false
        if($script:AppCategory -eq "Filtered"){
            $displayPackages=@($basePackages | Where-Object {
                $pkg=[string]$_
                if($appNamesBox -and $appNamesBox.Checked){
                    $label=Get-AppDisplayName $pkg
                    if($label -and (Test-AppFilterMatch -Package $label -Phrases $script:AppFilterPhrases -Mode $script:AppFilterMode)){return $true}
                }
                Test-AppFilterMatch -Package $pkg -Phrases $script:AppFilterPhrases -Mode $script:AppFilterMode
            })
        }
        $script:AppPackages=@($displayPackages)
        foreach($pkg in $script:AppPackages){$lv.Items.Add((Make-AppLVI $pkg))|Out-Null}
        $catTitle=switch($script:AppCategory){"System"{"System"};"Third-Party"{"Third-Party"};"Enabled"{"Enabled"};"Disabled"{"Disabled"};"Filtered"{"Filtered"};"Removed"{"Removed"};"Update System"{"Update System"};default{"All"}}
        $lblADB.Text="Applications: $catTitle";Update-AppFilterStatus
        if($lv.Items.Count -gt 0){$lv.Items[0].Selected=$true;$lv.Items[0].Focused=$true}
        $lv.Invalidate()
    }finally{$lv.EndUpdate()}
}
function Set-AppCategory {
    param([string]$category)

    if($category -eq "Select Apps"){
        $script:AppMode=$false
        $script:AppCategory="Select Apps"
        $script:AppBaseCategory="All"
        $script:AppFilter=""
        $script:AppFilterPhrases=@()
        $script:AppFilterMode="All"
        $global:SelectedPaths.Clear()
        $appFilterStatus.Text=""
        $appFilterPhrasesStatus.Text=""
        $appFilterModeStatus.Text=""
        $appFilterStatus.Visible=$false
        $appFilterPhrasesStatus.Visible=$false
        $appFilterModeStatus.Visible=$false
        $appNamesBox.Checked=$false;$appNamesBox.Visible=$false;$appNamesBtn.Visible=$false;$appResetBtn.Visible=$false;$script:AppNamesPrompted=$false
        $lblADB.Text=$currentAdbPath
        Refresh-Panel "ADB"
        $lvADB.Focus()
        return
    }

    if($category -eq "Filtered"){
        if(-not $script:AppMode -or $script:AppCategory -eq "Select Apps"){
            Set-Status "Select an application category first" "Yellow"
            $script:AppCategoryChanging=$true
            try{$appCatBox.SelectedItem="Select Apps"}finally{$script:AppCategoryChanging=$false}
            return
        }
        Filter-Applications
        return
    }

    if($script:AppMode -and $script:AppCategory -ne $category -and $appNamesBox -and $appNamesBox.Checked -and -not $script:AppCategoryChanging){
        $answer=[System.Windows.Forms.MessageBox]::Show($form,"The AppNames option is enabled. Switching categories may take some time because application names may need to be read again.`r`n`r`nContinue?","AppNames",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
        if($answer -ne [System.Windows.Forms.DialogResult]::Yes){
            $script:AppCategoryChanging=$true;try{$appCatBox.SelectedItem=$script:AppCategory}finally{$script:AppCategoryChanging=$false};return
        }
        $script:AppNamesPrompted=$true
    }
    $script:AppMode=$true
    $appNamesBox.Visible=$false;$appNamesBtn.Visible=$true;$appResetBtn.Visible=$true
    $script:AppCategory=$category
    $script:AppBaseCategory=$category
    $script:AppFilter=""
    $script:AppFilterPhrases=@()
    $script:AppFilterMode="All"
    $global:SelectedPaths.Clear()
    try{Refresh-AppList}finally{$script:AppNamesPrompted=$false}
    $lvADB.Focus()
    Add-Log "Application category: $category" -Level Detailed
}

function Show-AppFilterDialog {
    param([string]$oldPhrases,[string]$oldMode="All")

    $d=New-Object System.Windows.Forms.Form
    $d.Text=(T "dlg_filter_apps_title")
    $d.BackColor=$bgForm;$d.ForeColor=$clrText
    $d.FormBorderStyle="FixedDialog";$d.StartPosition="CenterParent";$d.KeyPreview=$true
    $d.Size=New-Object System.Drawing.Size(540,285)
    $d.MinimizeBox=$false;$d.MaximizeBox=$false

    $lbl=New-Object System.Windows.Forms.Label
    $lbl.Text=(T "dlg_filter_apps_lbl")
    $lbl.Location=New-Object System.Drawing.Point(20,18);$lbl.Size=New-Object System.Drawing.Size(490,24)
    $d.Controls.Add($lbl)

    $inp=New-Object System.Windows.Forms.TextBox
    $inp.Location=New-Object System.Drawing.Point(20,48);$inp.Size=New-Object System.Drawing.Size(490,28)
    $inp.Text=$oldPhrases
    $inp.BackColor=[System.Drawing.Color]::FromArgb(55,55,62);$inp.ForeColor=$clrText
    $d.Controls.Add($inp)

    $rbAll=New-Object System.Windows.Forms.RadioButton
    $rbAll.Text=(T "dlg_filter_apps_all")
    $rbAll.Location=New-Object System.Drawing.Point(20,90);$rbAll.Size=New-Object System.Drawing.Size(490,25)
    $rbAll.Checked=($oldMode -ne "Any");$d.Controls.Add($rbAll)

    $rbAny=New-Object System.Windows.Forms.RadioButton
    $rbAny.Text=(T "dlg_filter_apps_any")
    $rbAny.Location=New-Object System.Drawing.Point(20,120);$rbAny.Size=New-Object System.Drawing.Size(490,25)
    $rbAny.Checked=($oldMode -eq "Any");$d.Controls.Add($rbAny)

    $hint=New-Object System.Windows.Forms.Label
    $hint.Text=(T "dlg_filter_apps_hint")
    $hint.Location=New-Object System.Drawing.Point(20,154);$hint.Size=New-Object System.Drawing.Size(490,22)
    $hint.ForeColor=$clrDim;$d.Controls.Add($hint)

    $ok=New-Object System.Windows.Forms.Button;$ok.Text=(T "btn_ok");$ok.Size=New-Object System.Drawing.Size(90,30);$ok.FlatStyle="Flat"
    $cancel=New-Object System.Windows.Forms.Button;$cancel.Text=(T "btn_cancel");$cancel.Size=New-Object System.Drawing.Size(90,30);$cancel.FlatStyle="Flat"
    foreach($b in @($ok,$cancel)){$b.ForeColor=$clrText;$b.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$b.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(78,78,88)}
    # Center both buttons as a group using the actual client width/height.
    $groupW=190;$btnY=[int]($d.ClientSize.Height-50);$btnX=[int](($d.ClientSize.Width-$groupW)/2)
    $ok.Location=New-Object System.Drawing.Point($btnX,$btnY);$cancel.Location=New-Object System.Drawing.Point([int]($btnX+100),$btnY)
    $d.Controls.AddRange(@($ok,$cancel));$d.AcceptButton=$ok;$d.CancelButton=$cancel

    $script:AppFilterDialogResult=$null
    $ok.Add_Click({
        $parts=@($inp.Text -split ',' | ForEach-Object{$_.Trim()} | Where-Object{$_ -ne ""} | Sort-Object -Unique)
        $mode=if($rbAny.Checked){"Any"}else{"All"}
        $script:AppFilterDialogResult=@($parts,$mode)
        $d.DialogResult=[System.Windows.Forms.DialogResult]::OK
        $d.Close()
    })
    $cancel.Add_Click({$d.DialogResult=[System.Windows.Forms.DialogResult]::Cancel;$d.Close()})
    $d.Add_Shown({$inp.Focus();$inp.SelectAll()})

    $res=$d.ShowDialog($form)
    if($res -eq [System.Windows.Forms.DialogResult]::OK){return $script:AppFilterDialogResult}
    return $null
}

function Filter-Applications {
    if(-not $script:AppMode -or $script:AppCategory -eq "Select Apps"){
        Set-Status (T "msg_select_category_first") "Yellow"
        return
    }

    $base=if($script:AppCategory -eq "Filtered"){$script:AppBaseCategory}else{$script:AppCategory}
    if($base -eq "Select Apps"){$base="All"}

    $oldPhrases=if($script:AppFilterPhrases.Count -gt 0){$script:AppFilterPhrases -join ", "}else{$script:AppFilter}
    $r=Show-AppFilterDialog $oldPhrases $script:AppFilterMode
    if($null -eq $r){return}

    $script:AppBaseCategory=$base
    $script:AppFilterPhrases=@($r[0])
    $script:AppFilter=($script:AppFilterPhrases -join ", ")
    $script:AppFilterMode=[string]$r[1]
    $global:SelectedPaths.Clear()

    if($script:AppFilterPhrases.Count -eq 0){
        $script:AppCategory=$base
        $script:AppMode=$true
        Refresh-AppList
        $script:AppCategoryChanging=$true
        try{$appCatBox.SelectedItem=$base}finally{$script:AppCategoryChanging=$false}
        $lvADB.Focus()
        Add-Log (T "log_app_filter_cleared") -Level Detailed
        return
    }

    $script:AppCategory="Filtered"
    $script:AppMode=$true
    Refresh-AppList
    $script:AppCategoryChanging=$true
    try{$appCatBox.SelectedItem="Filtered"}finally{$script:AppCategoryChanging=$false}
    $lvADB.Focus()
    $modeKey=if($script:AppFilterMode -eq "Any"){"filter_mode_any"}else{"filter_mode_all"}
    Add-Log (T "log_app_filter_set" @($script:AppFilter,(T $modeKey))) -Level Detailed
}

function Get-AppSelectedPackages {
    param([switch]$AllowCurrent)
    $res=@()
    foreach($it in $lvADB.Items){
        $tag=[string]$it.Tag
        if($tag.StartsWith("APP:")){
            $pkg=$tag.Substring(4)
            if($global:SelectedPaths.Contains($pkg)){$res+=$pkg}
        }
    }
    if($res.Count -eq 0 -and $AllowCurrent){
        $it=Get-SelI $lvADB
        if($null -ne $it -and ([string]$it.Tag).StartsWith("APP:")){$res+=([string]$it.Tag).Substring(4)}
    }
    return @($res | Sort-Object -Unique)
}

function Confirm-AppAction {
    param([string]$title,[string]$message,[string[]]$packages)
    $names=@($packages)
    return $null -ne (Show-AdbDialog $title $message $null $names)
}

function Invoke-AppCommand {
    param([string]$command,[string[]]$packages,[string]$successText)
    $ok=0
    foreach($pkg in $packages){
        $out=& "$envAdb" shell $command $pkg 2>&1
        $rc=$LASTEXITCODE
        if($rc -eq 0){$ok++}else{
            $err=((@($out)|ForEach-Object{[string]$_}) -join " ").Trim()
            if($err){Add-Log "${pkg}: $err" "Red" -Level Error}else{Add-Log "${pkg}: command failed" "Red" -Level Error}
        }
    }
    if($ok -gt 0){Add-Log "${successText}: $ok application(s)" "Green" -Level Important}
    return $ok
}

function App-Uninstall {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_uninstall") (T "dlg_uninstall_q") $pkgs)){return}

    $ok=0
    foreach($pkg in $pkgs){
        $out=@(& "$envAdb" shell pm uninstall $pkg 2>&1)
        $rc=$LASTEXITCODE
        $msg=((@($out)|ForEach-Object{[string]$_}) -join " ").Trim()
        if($rc -ne 0){
            if($msg){Add-Log "${pkg}: uninstall command failed - $msg" "Red" -Level Error}
            else{Add-Log "${pkg}: uninstall command failed (exit code $rc)" "Red" -Level Error}
            continue
        }

        # Verify that the package is really absent from the installed package list.
        $check=@(& "$envAdb" shell pm list packages $pkg 2>&1)
        $stillInstalled=$false
        foreach($line in $check){
            $v=([string]$line).Trim() -replace '^package:',''
            if($v -eq $pkg){$stillInstalled=$true;break}
        }

        if($stillInstalled){
            if($msg){Add-Log "${pkg}: uninstall reported success, but the application is still installed. Android reported: $msg" "Red" -Level Error}
            else{Add-Log "${pkg}: uninstall reported success, but the application is still installed." "Red" -Level Error}
        }else{
            $ok++
            Add-Log "Deleted: $pkg" "Green" -Level Important
        }
    }
    if($ok -lt $pkgs.Count){Add-Log "Uninstall completed: $ok of $($pkgs.Count) application(s) removed." "Yellow" -Level Important}
    else{Add-Log "Uninstall completed: $ok application(s) removed." "Green" -Level Important}
    $global:SelectedPaths.Clear();Refresh-AppList
}

function App-ExtractFullPath {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    foreach($pkg in $pkgs){
        $out=@(& "$envAdb" shell pm list packages -f $pkg 2>&1)
        $rc=$LASTEXITCODE
        $lines=@($out|ForEach-Object{([string]$_).Trim()}|Where-Object{$_ -ne ""})
        if($rc -eq 0 -and $lines.Count -gt 0){
            Add-Log "Full package path for ${pkg}: $($lines -join ' | ')" "Blue" -Level Important
        }else{
            $err=($lines -join " ").Trim()
            if($err){Add-Log "Could not get full package path for ${pkg}: $err" "Red" -Level Error}
            else{Add-Log "Could not get full package path for ${pkg}." "Red" -Level Error}
        }
    }
}

function App-SoftUninstall {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_soft_uninstall") (T "dlg_soft_uninstall_q") $pkgs)){return}
    Invoke-AppCommand "pm uninstall -k" $pkgs "Soft-uninstalled"
    $global:SelectedPaths.Clear();Refresh-AppList
}

function App-ClearData {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_clear_data") (T "dlg_clear_data_q") $pkgs)){return}
    Invoke-AppCommand "pm clear" $pkgs "Cleared cache and data"
    $global:SelectedPaths.Clear();Refresh-AppList
}

function App-Disable {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_disable") (T "dlg_disable_q") $pkgs)){return}
    Invoke-AppCommand "pm disable-user --user 0" $pkgs "Disabled"
    $global:SelectedPaths.Clear();Refresh-AppList
}

function App-Enable {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    Invoke-AppCommand "pm enable" $pkgs "Enabled"
    $global:SelectedPaths.Clear();Refresh-AppList
}

function App-Launch {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_launch") (T "dlg_launch_q") $pkgs)){return}
    $ok=0
    foreach($pkg in $pkgs){
        $out=& "$envAdb" shell monkey -p $pkg 1 2>&1
        if($LASTEXITCODE -eq 0){$ok++}else{
            $err=((@($out)|ForEach-Object{[string]$_}) -join " ").Trim()
            Add-Log "${pkg}: launch failed$(if($err){": $err"})" "Red" -Level Error
        }
    }
    if($ok -gt 0){Add-Log "Launched: $ok application(s)" "Green" -Level Important}
}

function App-Kill {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_stop") (T "dlg_soft_stop_q") $pkgs)){return}
    Invoke-AppCommand "am kill" $pkgs "Soft-stopped"
}

function App-ForceStop {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_force_stop") (T "dlg_force_stop_q") $pkgs)){return}
    Invoke-AppCommand "am force-stop" $pkgs "Force-stopped"
}

function App-Restart {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_restart") (T "dlg_restart_q") $pkgs)){return}
    $ok=0
    foreach($pkg in $pkgs){
        & "$envAdb" shell am force-stop $pkg 2>&1 | Out-Null
        & "$envAdb" shell monkey -p $pkg 1 2>&1 | Out-Null
        if($LASTEXITCODE -eq 0){$ok++}else{Add-Log "${pkg}: restart failed" "Red" -Level Error}
    }
    if($ok -gt 0){Add-Log "Restarted: $ok application(s)" "Green" -Level Important}
}

function App-Status {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    $lines=@()
    foreach($pkg in $pkgs){
        $dump=@(& "$envAdb" shell dumpsys package $pkg 2>&1)
        if($LASTEXITCODE -ne 0){$lines+="Package: $pkg";$lines+="AppName: $pkg";$lines+="Status: package information unavailable";$lines+="";continue}
        $enabled="unknown";$stopped="unknown";$version="unknown";$uid="unknown";$inode="not available"
        $label=Get-AppLabelFromPackage $pkg $true
        if(-not $label){$label=$pkg}
        foreach($ln in $dump){
            $x=[string]$ln
            if($x -match '^\s*versionName=([^\s]+)'){$version=$Matches[1]}
            elseif($x -match '^\s*(?:userId|appId|uid)=(\d+)'){$uid=$Matches[1]}
            elseif($x -match '\buid=(\d+)'){$uid=$Matches[1]}
            if($x -match '^\s*pkgFlags=.*'){if($x -match 'STOPPED'){$stopped="yes"}else{$stopped="no"}}
            if($x -match '^\s*enabled=(true|false|default)'){$enabled=$Matches[1]}
            if($x -match 'User 0:\s*(.*ceDataInode[^\r\n]*)'){$inode=$Matches[1].Trim()}
        }
        $lines+="Package: $pkg";$lines+="AppName: $label";$lines+="Enabled: $enabled";$lines+="Stopped: $stopped";$lines+="Version: $version";$lines+="UID: $uid";$lines+="User 0: $inode";$lines+=""
    }
    Show-AdbDialog (T "dlg_app_status") ($lines -join "`r`n") $null @()
}
function App-Running {
    $raw=@(& "$envAdb" shell dumpsys activity processes 2>&1);$pkgs=@()
    foreach($ln in $raw){
        $x=[string]$ln
        foreach($m in [regex]::Matches($x,'(?:package=|ProcessRecord\{[^ ]+ [^: ]+:)([A-Za-z0-9_.$]+)')){$pkgs+=$m.Groups[1].Value}
    }
    $pkgs=@($pkgs | Where-Object{$_ -match '^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z0-9_$]+)+$'} | Sort-Object -Unique)
    if($pkgs.Count -eq 0){
        $pkgs=@(& "$envAdb" shell dumpsys activity activities 2>&1 | ForEach-Object{
            $x=[string]$_
            if($x -match '\b([A-Za-z][A-Za-z0-9_]*(?:\.[A-Za-z0-9_$]+)+)/[A-Za-z0-9_.$]+'){$Matches[1]}
        } | Sort-Object -Unique)
    }
    if($pkgs.Count -eq 0){Show-AdbDialog (T "dlg_running_apps") (T "msg_no_running_apps") $null @();return}
    Show-AdbDialog (T "dlg_running_apps") (T "msg_currently_running") $null $pkgs
}

function App-SaveSelected {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    $dlg=New-Object System.Windows.Forms.SaveFileDialog;$dlg.Title=(T "dlg_save_selected_apps");$dlg.Filter="Text files (*.txt)|*.txt|All files (*.*)|*.*";$dlg.FileName="selected_apps.txt";$dlg.InitialDirectory=[Environment]::GetFolderPath("Desktop")
    $res=$dlg.ShowDialog($form);if($res -ne [System.Windows.Forms.DialogResult]::OK){return}
    try{[System.IO.File]::WriteAllLines($dlg.FileName,$pkgs,(New-Object System.Text.UTF8Encoding($false)));Add-Log "Saved $($pkgs.Count) application(s) to $($dlg.FileName)" "Green" -Level Important}catch{Add-Log "Failed to save selected applications: $_" "Red" -Level Error}
}

function App-Restore {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_restore") (T "dlg_restore_q") $pkgs)){return}
    Invoke-AppCommand "pm install-existing --user 0" $pkgs "Restored"
    $global:SelectedPaths.Clear();Refresh-AppList
}

function App-RemoveUpdate {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    if(-not (Confirm-AppAction (T "dlg_confirm_remove_update") (T "dlg_remove_update_q") $pkgs)){return}
    $ok=0
    foreach($pkg in $pkgs){
        $out=& "$envAdb" shell pm uninstall --user 0 $pkg 2>&1
        if($LASTEXITCODE -eq 0){$ok++}else{
            $err=((@($out)|ForEach-Object{[string]$_}) -join " ").Trim()
            if($err){Add-Log "${pkg}: $err" "Red" -Level Error}else{Add-Log "${pkg}: remove update failed" "Red" -Level Error}
        }
    }
    if($ok -gt 0){Add-Log "Removed update: $ok application(s)" "Green" -Level Important}
    $global:SelectedPaths.Clear();Refresh-AppList
}

function App-FileBrowser {
    $script:AppMode=$false;$script:AppCategory="Select Apps";$script:AppFilter="";$script:AppFilterPhrases=@();$script:AppFilterMode="All";$global:SelectedPaths.Clear();$appFilterStatus.Text="";$appFilterPhrasesStatus.Text="";$appFilterModeStatus.Text="";$appFilterStatus.Visible=$false;$appFilterPhrasesStatus.Visible=$false;$appFilterModeStatus.Visible=$false;$lblADB.Text=$currentAdbPath;Refresh-Panel "ADB";$lvADB.Focus();Add-Log "Returned to Android file browser" -Level Detailed
    $appCatBox.SelectedItem="Select Apps"
}


function Show-AppExtractDialog {
    param([string[]]$packages)
    $d=New-Object System.Windows.Forms.Form
    $d.Text="Extract APK/OBB"
    $d.Size=New-Object System.Drawing.Size(560,360)
    $d.BackColor=$bgForm;$d.ForeColor=$clrText
    $d.FormBorderStyle="FixedDialog";$d.StartPosition="CenterParent";$d.KeyPreview=$true
    $d.MinimizeBox=$false;$d.MaximizeBox=$false

    $lbl=New-Object System.Windows.Forms.Label
    $lbl.Text="Extract the selected application package(s)"
    $lbl.Location=New-Object System.Drawing.Point(20,16);$lbl.Size=New-Object System.Drawing.Size(510,24)
    $d.Controls.Add($lbl)

    $countLbl=New-Object System.Windows.Forms.Label
    $countLbl.Text="Applications: $($packages.Count)"
    $countLbl.Location=New-Object System.Drawing.Point(20,43);$countLbl.Size=New-Object System.Drawing.Size(510,22)
    $d.Controls.Add($countLbl)

    $list=New-Object System.Windows.Forms.ListBox
    $list.Location=New-Object System.Drawing.Point(20,69);$list.Size=New-Object System.Drawing.Size(510,120)
    $list.BackColor=[System.Drawing.Color]::FromArgb(55,55,62);$list.ForeColor=$clrText
    $list.BorderStyle="FixedSingle"
    foreach($pkg in $packages){[void]$list.Items.Add($pkg)}
    $d.Controls.Add($list)

    $destLbl=New-Object System.Windows.Forms.Label
    $destLbl.Text="Destination folder:"
    $destLbl.Location=New-Object System.Drawing.Point(20,199);$destLbl.Size=New-Object System.Drawing.Size(120,22)
    $d.Controls.Add($destLbl)

    $dest=New-Object System.Windows.Forms.TextBox
    $dest.Text=if($currentLocalPath -eq "DRIVES"){"C:\"}else{$currentLocalPath}
    $dest.Location=New-Object System.Drawing.Point(140,197);$dest.Size=New-Object System.Drawing.Size(340,25)
    $dest.BackColor=[System.Drawing.Color]::FromArgb(55,55,62);$dest.ForeColor=$clrText
    $dest.BorderStyle="FixedSingle"
    $d.Controls.Add($dest)

    $browse=New-Object System.Windows.Forms.Button
    $browse.Text="...";$browse.Location=New-Object System.Drawing.Point(488,196);$browse.Size=New-Object System.Drawing.Size(42,26)
    $browse.FlatStyle="Flat";$browse.ForeColor=$clrText;$browse.BackColor=[System.Drawing.Color]::FromArgb(48,48,56)
    $browse.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80)
    $browse.Add_Click({
        $fb=New-Object System.Windows.Forms.FolderBrowserDialog
        $fb.Description="Select extraction folder"
        $initial=$dest.Text.Trim()
        if(Test-Path $initial -PathType Container){$fb.SelectedPath=$initial}
        if($fb.ShowDialog($d) -eq [System.Windows.Forms.DialogResult]::OK){$dest.Text=$fb.SelectedPath}
        $fb.Dispose()
    })
    $d.Controls.Add($browse)

    $obb=New-Object System.Windows.Forms.CheckBox
    $obb.Text="Also extract OBB files"
    $obb.Location=New-Object System.Drawing.Point(20,232);$obb.Size=New-Object System.Drawing.Size(240,25)
    $obb.ForeColor=$clrText;$obb.Checked=$false
    $d.Controls.Add($obb)

    $ok=New-Object System.Windows.Forms.Button;$ok.Text=(T "btn_ok");$ok.Size=New-Object System.Drawing.Size(90,30);$ok.FlatStyle="Flat"
    $cancel=New-Object System.Windows.Forms.Button;$cancel.Text=(T "btn_cancel");$cancel.Size=New-Object System.Drawing.Size(90,30);$cancel.FlatStyle="Flat"
    foreach($b in @($ok,$cancel)){$b.ForeColor=$clrText;$b.BackColor=[System.Drawing.Color]::FromArgb(52,52,60);$b.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(78,78,88)}
    $groupW=190;$btnY=[int]($d.ClientSize.Height-48);$btnX=[int](($d.ClientSize.Width-$groupW)/2)
    $ok.Location=New-Object System.Drawing.Point($btnX,$btnY);$cancel.Location=New-Object System.Drawing.Point([int]($btnX+100),$btnY)
    $d.Controls.AddRange(@($ok,$cancel));$d.AcceptButton=$ok;$d.CancelButton=$cancel

    $script:AppExtractDialogResult=$null
    $ok.Add_Click({
        $path=$dest.Text.Trim()
        if([string]::IsNullOrWhiteSpace($path) -or -not (Test-Path $path -PathType Container)){
            [System.Windows.Forms.MessageBox]::Show($d,"The destination folder does not exist.","Extract APK/OBB",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)|Out-Null
            $dest.Focus();return
        }
        $script:AppExtractDialogResult=@{IncludeObb=$obb.Checked;Destination=$path}
        $d.DialogResult=[System.Windows.Forms.DialogResult]::OK;$d.Close()
    })
    $cancel.Add_Click({$d.DialogResult=[System.Windows.Forms.DialogResult]::Cancel;$d.Close()})
    $res=$d.ShowDialog($form)
    if($res -eq [System.Windows.Forms.DialogResult]::OK){return $script:AppExtractDialogResult}
    return $null
}

function Invoke-AppExtractPull {
    param([string]$RemotePath,[string]$LocalDir,[string]$Label)
    if(-not (Test-Path $LocalDir -PathType Container)){New-Item -ItemType Directory -Path $LocalDir -Force -ErrorAction SilentlyContinue|Out-Null}
    $leaf=Split-Path ($RemotePath.TrimEnd('/')) -Leaf
    if([string]::IsNullOrWhiteSpace($leaf)){$leaf=$Label}
    $target=Join-Path $LocalDir $leaf
    $psi=New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName=$envAdb
    $psi.Arguments="pull `"$RemotePath`" `"$target`""
    $psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true;$psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
    $psi.StandardOutputEncoding=[System.Text.Encoding]::UTF8;$psi.StandardErrorEncoding=[System.Text.Encoding]::UTF8
    $proc=New-Object System.Diagnostics.Process;$proc.StartInfo=$psi
    [void]$proc.Start()
    $tO=$proc.StandardOutput.ReadToEndAsync();$tE=$proc.StandardError.ReadToEndAsync()
    $sw=[System.Diagnostics.Stopwatch]::StartNew()
    while(-not $proc.HasExited){
        Set-Status "Extracting: $Label" "Blue"
        [System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 150
    }
    $out=$tO.Result+$tE.Result;$rc=$proc.ExitCode
    if($rc -ne 0){
        $err=((@($out)|ForEach-Object{[string]$_}) -join " ").Trim()
        if($err){Add-Log "Extract failed: $Label - $err" "Red" -Level Error}else{Add-Log "Extract failed: $Label" "Red" -Level Error}
        return $false
    }
    Add-Log "Extracted: $Label" "Green" -Level Important
    return $true
}

function App-Extract {
    $pkgs=Get-AppSelectedPackages -AllowCurrent
    if($pkgs.Count -eq 0){return}
    $choice=Show-AppExtractDialog $pkgs
    if($null -eq $choice){return}
    $includeObb=[bool]$choice.IncludeObb
    $destination=[string]$choice.Destination
    $ok=0;$fail=0
    foreach($pkg in $pkgs){
        $pkgDir=Join-Path $destination $pkg
        if(-not (Test-Path $pkgDir -PathType Container)){New-Item -ItemType Directory -Path $pkgDir -Force -ErrorAction SilentlyContinue|Out-Null}
        Set-Status "Extracting: $pkg" "Blue"
        $paths=@(& "$envAdb" shell pm path $pkg 2>&1 | ForEach-Object{([string]$_).Trim() -replace '^package:',''} | Where-Object{$_ -and $_ -match '^/'})
        if($paths.Count -eq 0){Add-Log "Extract failed: ${pkg}: APK path not found" "Red" -Level Error;$fail++;continue}
        $pkgOk=$true
        $baseLocal=$null
        $apkIndex=0
        foreach($remote in $paths){
            $apkIndex++
            $leaf=Split-Path ($remote.TrimEnd('/')) -Leaf
            if([string]::IsNullOrWhiteSpace($leaf)){$leaf="split_$apkIndex.apk"}
            if(-not (Invoke-AppExtractPull $remote $pkgDir "${pkg}: $leaf")){$pkgOk=$false}
            elseif($leaf -ieq "base.apk"){$baseLocal=Join-Path $pkgDir $leaf}
        }
        if($baseLocal -and (Test-Path $baseLocal -PathType Leaf)){
            $label=Get-AaptLabel $baseLocal
            if(-not [string]::IsNullOrWhiteSpace($label)){
                $safe=$label -replace '[\\/:*?"<>|]','_'
                $safe=$safe.Trim().TrimEnd('.')
                if(-not [string]::IsNullOrWhiteSpace($safe)){
                    $newApk=Join-Path $pkgDir ($safe + ".apk")
                    if(-not ($newApk -ieq $baseLocal)){
                        if(Test-Path $newApk -PathType Leaf){Remove-Item -LiteralPath $newApk -Force -ErrorAction SilentlyContinue}
                        try{Move-Item -LiteralPath $baseLocal -Destination $newApk -Force -ErrorAction Stop;Add-Log "Renamed base.apk: $pkg -> $safe.apk" "Green" -Level Detailed}
                        catch{Add-Log "Could not rename base.apk for ${pkg}: $($_.Exception.Message)" "Yellow" -Level Detailed}
                    }
                }
            }
        }
        if($includeObb){
            $obbRemote="/sdcard/Android/obb/$pkg/."
            $obbDir=Join-Path $pkgDir "OBB"
            $check=@(& "$envAdb" shell ls -d "/sdcard/Android/obb/$pkg" 2>&1)
            $hasObb=$false
            foreach($x in $check){if(([string]$x).Trim() -eq "/sdcard/Android/obb/$pkg"){$hasObb=$true;break}}
            if($hasObb){
                $obbList=@(& "$envAdb" shell ls -1 "/sdcard/Android/obb/$pkg" 2>&1 | ForEach-Object {([string]$_).Trim()} | Where-Object {$_ -and $_ -notmatch '^ls:'})
                $obbList=@($obbList | Where-Object {$_ -match '\.obb$'})
                if($obbList.Count -gt 0){
                    if(-not (Test-Path $obbDir -PathType Container)){New-Item -ItemType Directory -Path $obbDir -Force -ErrorAction SilentlyContinue|Out-Null}
                    if(-not (Invoke-AppExtractPull $obbRemote $obbDir "${pkg}: OBB")){$pkgOk=$false}
                }else{
                    Add-Log "OBB does not exist: $pkg" "Yellow" -Level Important
                }
            }else{Add-Log "OBB does not exist: $pkg" "Yellow" -Level Important}
        }
        if($pkgOk){$ok++}else{$fail++}
    }
    Set-Status "Extract complete: $ok succeeded, $fail failed" $(if($fail -gt 0){"Yellow"}else{"Green"})
    if($destination -eq $currentLocalPath){Refresh-Panel "PC"}
    $lvPC.Focus()
}

function Show-AppCtxMenu {
    param($lv)
    $ctxMenu.Items.Clear();$mp=[System.Windows.Forms.Control]::MousePosition;$cp=$lv.PointToClient($mp);$hit=$lv.HitTest($cp.X,$cp.Y)
    if($null -ne $hit.Item){$hit.Item.Selected=$true;$hit.Item.Focused=$true;$lv.Focus()}
    $script:CtxLVRef=$lv;$script:CtxIsPC=$false;$item=Get-SelI $lv
    if($null -eq $item -or -not ([string]$item.Tag).StartsWith("APP:")){
        Add-MI (T "ctx_back_to_browser") "App-FileBrowser" $true;$ctxMenu.Show($mp);return
    }
    $script:CtxItem=$item;$script:CtxPath=([string]$item.Tag).Substring(4);$script:CtxIsDir=$false;$script:CtxSnap=@(Get-AppSelectedPackages -AllowCurrent)
    $cat=$script:AppCategory

    # Common application operations are always available.
    Add-MI (T "hlp_op_uninstall_k") "App-Uninstall" $true
    Add-MI (T "ctx_soft_uninstall") "App-SoftUninstall" $true
    Add-MI (T "hlp_op_clear_k") "App-ClearData" $true
    $ctxMenu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))|Out-Null
    Add-MI (T "hlp_op_disable_k") "App-Disable" $true
    Add-MI (T "hlp_op_enable_k") "App-Enable" $true
    $ctxMenu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))|Out-Null
    Add-MI (T "hlp_op_launch_k") "App-Launch" $true
    Add-MI (T "ctx_soft_stop") "App-Kill" $true
    Add-MI (T "ctx_force_stop") "App-ForceStop" $true
    Add-MI (T "hlp_op_restart_k") "App-Restart" $true
    $ctxMenu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))|Out-Null
    Add-MI (T "hlp_op_status_k") "App-Status" $true
    Add-MI (T "hlp_op_running_k") "App-Running" $true
    Add-MI (T "ctx_save_selected") "App-SaveSelected" $true
    Add-MI (T "hlp_op_extract_k") "App-Extract" $true
    Add-MI (T "hlp_op_fullpath_k") "App-ExtractFullPath" $true

    # Category-specific recovery operations are kept at the bottom.
    if($cat -eq "Removed"){
        $ctxMenu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))|Out-Null
        Add-MI (T "ctx_restore_app") "App-Restore" $true
    }elseif($cat -eq "Update System"){
        $ctxMenu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))|Out-Null
        Add-MI (T "hlp_op_removeupd_k") "App-RemoveUpdate" $true
    }
    $ctxMenu.Show($mp)
}

# ARCHIVE SUPPORT
$extArch=@("zip","7z","rar","gz","tar","bz2","xz","cab","iso","tgz","tbz2","z01","z02","z03","z04","z05","001","002","003")

function Is-ArchiveFile{param([string]$n)
    $e="";$d=$n.LastIndexOf(".");if($d -ge 0){$e=$n.Substring($d+1).ToLower()}
    if($extArch -contains $e){return $true}
    if($n -match "(?i)\.7z\.[0-9]+$"){return $true}
    return $false}

function List-Archive{param([string]$archPath,[string]$subDir="")
    if(-not(Test-Path $env7z -ErrorAction SilentlyContinue)){Add-Log "$(T 'msg_7z_not_found'): $env7z" "Red";return @()}
    $psi2=New-Object System.Diagnostics.ProcessStartInfo
    $psi2.FileName=$env7z
    $psi2.Arguments="l `"$archPath`""
    $psi2.UseShellExecute=$false;$psi2.CreateNoWindow=$true
    $psi2.RedirectStandardOutput=$true;$psi2.RedirectStandardError=$true
    $psi2.StandardOutputEncoding=[System.Text.Encoding]::GetEncoding(866)
    $proc2=New-Object System.Diagnostics.Process;$proc2.StartInfo=$psi2;[void]$proc2.Start()
    $tO2=$proc2.StandardOutput.ReadToEndAsync()
    $proc2.WaitForExit()
    $out=[string]$tO2.Result
    $allLines=$out -split "`r?`n"
    $sepCount=0;$items=@()
    foreach($line in $allLines){
        if($line -match "^[-]{5,}"){$sepCount++;continue}
        if($sepCount -lt 1 -or $sepCount -ge 2){continue}
        if($line.Trim() -eq ""){continue}
        if($line.Length -lt 26){continue}
        $attr=$line.Substring(20,5).Trim()
        $isDir=$attr.Contains("D")
        $sz=0L
        if(-not $isDir -and $line.Length -gt 39){
            $szStr=$line.Substring(26,12).Trim()
            if($szStr -match "^[0-9]+$"){$sz=[long]$szStr}}
        $name=if($line.Length -gt 53){$line.Substring(53).Trim()}else{""}
        if($name -eq ""){continue}
        $name=$name -replace "\\","/"
        $items+=@{Name=$name;Size=$sz;IsDir=$isDir}}
    $prefix=if($subDir -ne "" -and -not $subDir.EndsWith("/")){$subDir+"/"}else{$subDir}
    $seen=@{};$result=@()
    foreach($it in $items){
        $n=$it.Name.TrimEnd("/")
        if($n -eq ""){continue}
        if($prefix -ne ""){
            if(-not $n.StartsWith($prefix)){continue}
            $n=$n.Substring($prefix.Length)
            if($n -eq ""){continue}}
        $slash=$n.IndexOf("/")
        if($slash -ge 0){
            $topName=$n.Substring(0,$slash)
            if($topName -eq "" -or $seen.ContainsKey($topName)){continue}
            $seen[$topName]=$true
            $innerPath=if($prefix -ne ""){$prefix+$topName}else{$topName}
            $result+=@{Name=$topName;InnerPath=$innerPath;Size=0L;IsDir=$true}
        }else{
            if($seen.ContainsKey($n)){continue}
            $seen[$n]=$true
            $innerPath=if($prefix -ne ""){$prefix+$n}else{$n}
            $result+=@{Name=$n;InnerPath=$innerPath;Size=$it.Size;IsDir=$it.IsDir}}}
    return $result}

function Resolve-MultipartArchivePath{param([string]$path)
    # 7-Zip's own multi-volume auto-detection (finding and joining sibling volumes)
    # only recognizes the zero-padded convention it produces itself: name.7z.001, .002, ...
    # Files named name.7z.1, name.7z.2, ... (no padding) are NOT recognized by 7z.exe at all,
    # so opening even the first one alone fails with "Unexpected end of archive" once 7z
    # reaches the point where volume 2 should continue - it never looks for a sibling
    # named ".2". To fix this we build zero-padded hardlinks (no extra disk space; falls
    # back to a copy if hardlinking isn't possible, e.g. across drives) next to a temp
    # folder, pointing at the exact same data, and hand 7z.exe the properly-named first
    # volume instead - its native join logic then finds ".002", ".003", etc. by itself.
    $name=Split-Path $path -Leaf
    if($name -notmatch "(?i)^(.+\.7z)\.([0-9]+)$"){return $path}
    $baseLeaf=$Matches[1];$width=$Matches[2].Length
    if($width -ge 3){
        # Standard 7-Zip zero-padded convention - 7z.exe auto-joins these natively,
        # but still needs to be pointed at the first volume specifically.
        $firstNum=([string]1).PadLeft($width,'0')
        if($Matches[2] -eq $firstNum){return $path}
        $first=$path -replace "\.[0-9]+$",".$firstNum"
        if(Test-Path -LiteralPath $first){return $first}
        return $path
    }
    $dir=Split-Path $path -Parent
    $vols=@();$n=1
    while($true){
        $cand=Join-Path $dir "$baseLeaf.$n"
        if(Test-Path -LiteralPath $cand){$vols+=$cand;$n++}else{break}
    }
    if($vols.Count -eq 0){return $path}
    try{
        $md5=[System.Security.Cryptography.MD5]::Create()
        $hb=$md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("$dir|$baseLeaf"))
        $hash=([System.BitConverter]::ToString($hb) -replace "-","").Substring(0,12)
    }catch{$hash=[string](Get-Random)}
    $linkDir=Join-Path $script:WorkDir "mvol_$hash"
    if(-not(Test-Path -LiteralPath $linkDir)){New-Item -ItemType Directory -Path $linkDir -Force|Out-Null}
    $firstLink=$null
    for($i=0;$i -lt $vols.Count;$i++){
        $idx=$i+1;$padded="{0:D3}" -f $idx
        $linkPath=Join-Path $linkDir "$baseLeaf.$padded"
        if(-not(Test-Path -LiteralPath $linkPath)){
            try{New-Item -ItemType HardLink -Path $linkPath -Target $vols[$i] -ErrorAction Stop|Out-Null}
            catch{
                try{Copy-Item -LiteralPath $vols[$i] -Destination $linkPath -Force}
                catch{Add-Log "$(T 'msg_multipart_link_failed'): $($vols[$i])" "Red";return $path}
            }
        }
        if($idx -eq 1){$firstLink=$linkPath}
    }
    return $firstLink
}
function Get-ArchiveFirstPart{param([string]$path)
    # Returns the first-part path for multivolume archives, or $path if not multivolume
    $dir=Split-Path $path -Parent
    $name=Split-Path $path -Leaf
    # .7z.001 / .7z.1 -> already first part
    # .7z.NNN or .7z.N -> resolve to a path 7z.exe can actually open, joining any
    # non-padded sibling volumes (.1, .2, .3, ...) via Resolve-MultipartArchivePath.
    # Standard zero-padded volumes (.001, .002, ...) pass through unchanged - 7z.exe
    # already auto-joins those natively.
    if($name -match "(?i)\.7z\.([0-9]+)$"){
        return Resolve-MultipartArchivePath $path}
    # .partN.rar -> find .part1.rar
    if($name -match "\.part([0-9]+)\.rar$"){
        $first=$path -replace "\.part[0-9]+\.rar$",".part1.rar"
        if(Test-Path -LiteralPath $first){return $first}
        return $path}
    # .zNN -> find the .zip
    if($name -match "\.z[0-9]+$"){
        $base=$path -replace "\.z[0-9]+$",".zip"
        if(Test-Path -LiteralPath $base){return $base}
        return $path}
    # .NNN (generic split) -> find .001
    if($name -match "^(.+)\.[0-9]{3}$"){
        $first=$path -replace "\.[0-9]{3}$",".001"
        if(Test-Path -LiteralPath $first){return $first}
        return $path}
    return $path}

function Is-MultipartNotFirst{param([string]$path)
    $name=Split-Path $path -Leaf
    if($name -match "(?i)\.7z\.([0-9]+)$"){
        $numStr=$Matches[1];$width=$numStr.Length
        $firstNum=([string]1).PadLeft($width,'0')
        if($numStr -ne $firstNum){return $true}}
    if($name -match "\.part([0-9]+)\.rar$" -and [int]$Matches[1] -gt 1){return $true}
    if($name -match "\.z([0-9]+)$" -and [int]$Matches[1] -gt 1){return $true}
    if($name -match "\.([0-9]{3})$" -and $Matches[1] -ne "001"){return $true}
    return $false}

function Open-Archive{param([string]$archPath,[bool]$isPC=$true)
    $script:ArchivePath=$archPath;$script:ArchiveIsPC=$isPC
    $script:ArchiveName=Split-Path $archPath -Leaf
    $script:ArchiveSubDir=""
    Refresh-ArchPanel}

function Refresh-ArchPanel{
    $archPath=$script:ArchivePath
    $subDir=if($null -ne $script:ArchiveSubDir){$script:ArchiveSubDir}else{""}
    $lv=if($script:ArchiveIsPC){$lvPC}else{$lvADB}
    $lbl=if($script:ArchiveIsPC){$lblPC}else{$lblADB}
    $lv.BeginUpdate();$lv.Items.Clear()
    $subLabel=if($subDir -ne ""){"/$subDir"}else{""}
    $lbl.Text="[ARCH] $archPath$subLabel"
    $goUp=New-Object System.Windows.Forms.ListViewItem(".. [Close Archive]")
    $goUp.SubItems.Add("")|Out-Null;$goUp.SubItems.Add("")|Out-Null;$goUp.SubItems.Add("0")|Out-Null
    $goUp.Tag="__ARCHCLOSE__";$lv.Items.Add($goUp)|Out-Null
    $items=List-Archive $archPath $subDir
    $dirs=@();$files=@()
    foreach($it in $items){
        $li=New-Object System.Windows.Forms.ListViewItem($it.Name)
        $szD=if($it.IsDir){"<Dir>"}else{Format-Bytes $it.Size}
        $li.SubItems.Add($szD)|Out-Null
        $li.SubItems.Add("")|Out-Null
        $li.SubItems.Add([string]$it.Size)|Out-Null
        $li.Tag="ARCH:$($it.InnerPath)"
        if($it.IsDir){$dirs+=$li}else{$files+=$li}}
    foreach($li in $dirs){$lv.Items.Add($li)|Out-Null}
    foreach($li in $files){$lv.Items.Add($li)|Out-Null}
    if($lv.Items.Count -gt 0){$lv.Items[0].Selected=$true;$lv.Items[0].Focused=$true}
    $lv.EndUpdate()}

function Show-ExtractDialog{param([string]$archName)
    $d=New-Object System.Windows.Forms.Form;$d.Text="$(T 'dlg_extract_title'): $archName"
    $d.Size="560,330";$d.BackColor=$bgForm;$d.ForeColor=$clrText
    $d.FormBorderStyle="FixedDialog";$d.StartPosition="CenterParent";$d.KeyPreview=$true
    $d.GetType().GetProperty("DoubleBuffered",[System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).SetValue($d,$true,$null)
    $lblPC2=New-Object System.Windows.Forms.Label;$lblPC2.Text=(T "dlg_pc_path");$lblPC2.Location="20,18";$lblPC2.Size="60,20";$lblPC2.ForeColor=$clrDim;$d.Controls.Add($lblPC2)
    $txtPC=New-Object System.Windows.Forms.TextBox;$txtPC.Location="82,15";$txtPC.Size="380,24"
    $txtPC.BackColor=[System.Drawing.Color]::FromArgb(50,50,58);$txtPC.ForeColor=$clrText;$txtPC.BorderStyle="FixedSingle"
    $archBase=[System.IO.Path]::GetFileNameWithoutExtension($archName)
    $txtPC.Text=Join-Path $currentLocalPath $archBase;$d.Controls.Add($txtPC)
    $btnBrowse=New-Object System.Windows.Forms.Button;$btnBrowse.Text="...";$btnBrowse.Location="466,14";$btnBrowse.Size="54,26"
    $btnBrowse.FlatStyle="Flat";$btnBrowse.ForeColor=$clrText;$btnBrowse.BackColor=[System.Drawing.Color]::FromArgb(48,48,56)
    $btnBrowse.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80)
    $btnBrowse.Add_Click({
        $fb=New-Object System.Windows.Forms.FolderBrowserDialog
        $fb.SelectedPath=$txtPC.Text;$fb.Description=(T "dlg_select_extract_folder")
        if($fb.ShowDialog() -eq "OK"){$txtPC.Text=$fb.SelectedPath}})
    $d.Controls.Add($btnBrowse)
    $btnPC=New-Object System.Windows.Forms.Button
    $btnPC.Text=(T "dlg_unpack_to_pc")
    $btnPC.Location="20,50";$btnPC.Size="500,36";$btnPC.FlatStyle="Flat"
    $btnPC.ForeColor=$clrText;$btnPC.BackColor=[System.Drawing.Color]::FromArgb(48,48,56)
    $btnPC.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80);$btnPC.TextAlign="MiddleCenter"
    $btnPC.Add_Click({$d.Tag=$txtPC.Text;$d.DialogResult="Yes";$d.Close()})
    $d.Controls.Add($btnPC)
    $lblADB2=New-Object System.Windows.Forms.Label;$lblADB2.Text=(T "dlg_android_colon");$lblADB2.Location="20,108";$lblADB2.Size="520,20";$lblADB2.ForeColor=$clrDim;$d.Controls.Add($lblADB2)
    $lblADBPath=New-Object System.Windows.Forms.Label
    $lblADBPath.Text=$currentAdbPath;$lblADBPath.Location="20,128";$lblADBPath.Size="520,20"
    $lblADBPath.ForeColor=$clrGold;$d.Controls.Add($lblADBPath)
    $btnADB=New-Object System.Windows.Forms.Button
    $btnADB.Text="$(T 'dlg_unpack_to_android')  [Enter]"
    $btnADB.Location="20,158";$btnADB.Size="500,36";$btnADB.FlatStyle="Flat"
    $btnADB.ForeColor=$clrText;$btnADB.BackColor=[System.Drawing.Color]::FromArgb(28,78,148)
    $btnADB.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(60,120,220);$btnADB.TextAlign="MiddleCenter"
    $btnADB.Add_Click({$d.Tag="ADB";$d.DialogResult="No";$d.Close()})
    $d.Controls.Add($btnADB)
    $btnCn=New-Object System.Windows.Forms.Button;$btnCn.Text=(T "btn_cancel")
    $btnCn.Location="430,252";$btnCn.Size="90,30";$btnCn.FlatStyle="Flat"
    $btnCn.ForeColor=$clrDim;$btnCn.BackColor=[System.Drawing.Color]::FromArgb(42,42,46)
    $btnCn.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(60,60,68)
    $btnCn.DialogResult="Cancel";$d.Controls.Add($btnCn)
    $d.CancelButton=$btnCn
    # Android is default (Enter)
    $d.AcceptButton=$btnADB
    $d.Add_Shown({$btnADB.Focus()})
    $result=$d.ShowDialog()
    return @{Result=$result;PCPath=$d.Tag}}

function Extract-FromArchive{param([string]$archPath,[string[]]$innerPaths,[string]$destDir,[bool]$flat=$false)
    if(-not(Test-Path $env7z -ErrorAction SilentlyContinue)){Add-Log (T "msg_7z_not_found") "Red";return}
    New-Item -ItemType Directory -Path $destDir -Force -ErrorAction SilentlyContinue|Out-Null
    $prBg.Visible=$true;$prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=0
    $sw=[System.Diagnostics.Stopwatch]::StartNew();$p=0;$d=1
    if($innerPaths.Count -eq 0){
        # Extract all with full structure
        $args7="x `"$archPath`" -o`"$destDir`" -aoa -y"
    }else{
        $listFile=Join-Path $script:WorkDir "adbfm_7zlist.txt"
        [System.IO.File]::WriteAllLines($listFile,$innerPaths,[System.Text.Encoding]::UTF8)
        if($flat){
            # "e" = extract without directory structure (files only, flat)
            $args7="e `"$archPath`" @`"$listFile`" -o`"$destDir`" -aoa -y"
        }else{
            # "x" = extract with full directory structure
            $args7="x `"$archPath`" @`"$listFile`" -o`"$destDir`" -aoa -y"
        }
    }
    $psi=New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName=$env7z;$psi.Arguments=$args7
    $psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
    $psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
    $proc=New-Object System.Diagnostics.Process;$proc.StartInfo=$psi;$script:CurrentProc=$proc;[void]$proc.Start()
    $tO=$proc.StandardOutput.ReadToEndAsync();$tE=$proc.StandardError.ReadToEndAsync()
    while((-not $proc.HasExited) -and (-not $script:StopRequested)){
        Set-Status "$(T 'st_extracting')...  [$([int]$sw.Elapsed.TotalSeconds)s]"
        $r2=Anim-Bar $p $d;$p=[int]$r2[0];$d=[int]$r2[1]
        [System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 80}
    $script:CurrentProc=$null
    if($innerPaths.Count -gt 0){
        $lf=Join-Path $script:WorkDir "adbfm_7zlist.txt"
        if(Test-Path $lf){Remove-Item $lf -ErrorAction SilentlyContinue}}
    $prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=[int]$prBg.Width
    if($script:StopRequested){
        try{if(-not $proc.HasExited){$proc.Kill()}}catch{}
        Add-Log (T "log_paste_cancelled") "Yellow"
        $form.Update();Start-Sleep -Milliseconds 300;$prBg.Visible=$false;$prFl.Width=0;return}
    $errOut=$tE.Result.Trim()
    if($proc.ExitCode -ne 0 -and $errOut){Add-Log "$(T 'st_extract_error'): $errOut" "Red"}
    else{Add-Log "$(T 'log_extracted_to'): $destDir" "Green"}
    $form.Update();Start-Sleep -Milliseconds 300;$prBg.Visible=$false;$prFl.Width=0}

function Pack-ToArchive{param([string[]]$srcPaths,[string]$archName,[string]$destDir)
    if(-not(Test-Path $env7z -ErrorAction SilentlyContinue)){Add-Log (T "msg_7z_not_found") "Red";return}
    $archPath=Join-Path $destDir $archName
    $prBg.Visible=$true;$prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=0
    $sw=[System.Diagnostics.Stopwatch]::StartNew();$p=0;$d=1
    $args7="a `"$archPath`""
    foreach($s in $srcPaths){$args7+=" `"$s`""}
    $psi=New-Object System.Diagnostics.ProcessStartInfo;$psi.FileName=$env7z;$psi.Arguments=$args7
    $psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
    $psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
    $script:StopRequested=$false
    $proc=New-Object System.Diagnostics.Process;$proc.StartInfo=$psi;$script:CurrentProc=$proc;[void]$proc.Start()
    $tO=$proc.StandardOutput.ReadToEndAsync();$tE=$proc.StandardError.ReadToEndAsync()
    while((-not $proc.HasExited) -and (-not $script:StopRequested)){
        Set-Status "$(T 'st_packing'): $archName  [$([int]$sw.Elapsed.TotalSeconds)s]"
        $r=Anim-Bar $p $d;$p=[int]$r[0];$d=[int]$r[1]
        [System.Windows.Forms.Application]::DoEvents();Start-Sleep -Milliseconds 80}
    $script:CurrentProc=$null
    $prFl.Location=New-Object System.Drawing.Point(0,0);$prFl.Width=[int]$prBg.Width
    if($script:StopRequested){
        try{if(-not $proc.HasExited){$proc.Kill()}}catch{}
        Add-Log (T "log_paste_cancelled") "Yellow";$script:StopRequested=$false
        $form.Update();Start-Sleep -Milliseconds 300;$prBg.Visible=$false;$prFl.Width=0;return}
    Add-Log "$(T 'log_packed'): $archName" "Green";$form.Update();Start-Sleep -Milliseconds 300;$prBg.Visible=$false;$prFl.Width=0}

function Test-EditableArchive{param([string]$path)
    $name=Split-Path $path -Leaf
    if($name -match '\.(zip|7z)$'){return $true}
    if($name -match '(?i)\.7z\.[0-9]+$'){return $true}
    return $false}

function Update-FileInArchive {
    param(
        [string]$ArchivePath,
        [string]$InnerPath,
        [string]$TmpDir
    )

    if (-not (Test-Path $env7z)) {
        Add-Log (T "msg_7z_not_found") "Red"
        return $false
    }

    # Полный путь к временному файлу
    $fullTmpFilePath = Join-Path $TmpDir $InnerPath

    if (-not (Test-Path -LiteralPath $fullTmpFilePath)) {
        Add-Log "Temp file not found: $fullTmpFilePath" "Red"
        return $false
    }

    # Настройка процесса запуска 7z
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $env7z
    
    # -sccUTF-8 говорит 7-Zip использовать UTF-8 для консольных аргументов
    $psi.Arguments = "u `"$ArchivePath`" `"$InnerPath`" -sccUTF-8 -y"
    
    # КРИТИЧЕСКИ ВАЖНО: устанавливаем рабочую директорию равной временной папке
    $psi.WorkingDirectory = $TmpDir
    
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    
    # Чтение вывода 7-Zip в кодировке OEM (866), чтобы логи были читаемыми
    $psi.StandardOutputEncoding = [System.Text.Encoding]::GetEncoding(65001)
    $psi.StandardErrorEncoding = [System.Text.Encoding]::GetEncoding(65001)

    try {
        $proc = [System.Diagnostics.Process]::Start($psi)
        $out = $proc.StandardOutput.ReadToEnd() + $proc.StandardError.ReadToEnd()
        $proc.WaitForExit()

        if ($proc.ExitCode -eq 0) {
            Add-Log "Archive updated successfully: $InnerPath" "Green"
            return $true
        } else {
            Add-Log "Archive update error: $out" "Red"
            return $false
        }
    } catch {
        Add-Log "Exception during archive update: $_" "Red"
        return $false
    }
}

function Escape-AdbShell{param([string]$p)
    # Use single-quotes for Android shell - handles spaces, [], special chars
    # Escape embedded single-quotes: replace ' with '''
    $e=$p -replace [char]39,([string][char]39+[string][char]92+[string][char]39+[string][char]39)
    return [string][char]39+$e+[string][char]39}

function AdbMkdir{param([string]$p)
    $q=Escape-AdbShell $p
    & "$envAdb" shell ('mkdir -p '+$q) 2>&1 | Out-Null}

function AdbMkdir{param([string]$p)
    $cmd='mkdir -p '+(Escape-AdbShell $p)
    & "$envAdb" shell $cmd 2>&1 | Out-Null}

function New-TmpDir{
    $guid=[System.Guid]::NewGuid().ToString("N")
    $d=Join-Path $script:WorkDir $guid
    $created=New-Item -ItemType Directory -Path $d -Force
    # Return the actual resolved path (handles short vs long path names)
    return $created.FullName}

function Unpack-Action{param($lv,$item)
    $script:StopRequested=$false
    $ti=Get-ItemTag $item
    $archPath=$ti.Path
    $archName=Split-Path $archPath -Leaf
    $localArchPath=$archPath
    if($lv -ne $lvPC){
        $localArchPath=Join-Path $script:WorkDir $archName
        Set-Status "$(T 'st_pulling_archive')..." "Blue"
        & "$envAdb" pull "`"$archPath`"" "`"$localArchPath`"" 2>&1 | Out-Null
        if(-not(Test-Path -LiteralPath $localArchPath)){
            Add-Log (T "log_pull_archive_failed") "Red"
            return
        }
    }
    $dlg=Show-ExtractDialog $archName
    if($dlg.Result -eq "Cancel"){return}
    $tmpDir=New-TmpDir
    try{
        if($dlg.Result -eq "Yes"){
            # PC: extract directly to chosen destination
            Extract-FromArchive $localArchPath @() $dlg.PCPath
            Refresh-Panel "PC"
        }else{
            # Android: extract to tmp, push ALL content under archBase dir
            Extract-FromArchive $localArchPath @() $tmpDir
            if($script:StopRequested){Add-Log (T "log_paste_cancelled") "Yellow";$script:StopRequested=$false;return}
            # Resolve to actual long path to fix short/long path Substring mismatch
            $tmpDir=(Get-Item -LiteralPath $tmpDir).FullName
            $archBase=[System.IO.Path]::GetFileNameWithoutExtension($archName)
            $adbDest="$($currentAdbPath.TrimEnd("/"))/$archBase"
            AdbMkdir $adbDest
            # Push everything from tmpDir into adbDest (preserving archive structure)
            $allDirs=@(Get-ChildItem -LiteralPath $tmpDir -Recurse -Directory|Sort-Object FullName)
            $allFiles=@(Get-ChildItem -LiteralPath $tmpDir -Recurse -File)
            $total=$allDirs.Count+$allFiles.Count;$idx=0
            foreach($pd in $allDirs){
                $idx++
                $rel=$pd.FullName.Substring($tmpDir.Length+1) -replace "\\","/"
                AdbMkdir "$adbDest/$rel"
                Set-Status "$(T 'st_creating_dir') ($idx/$total): $($pd.Name)" "Blue"
            }
            foreach($pf in $allFiles){
                $idx++
                $rel=$pf.FullName.Substring($tmpDir.Length+1) -replace "\\","/"
                $pdest="$adbDest/$rel"
                Set-Status "$(T 'st_pushing') ($idx/$total): $($pf.Name)" "Blue"
                Invoke-Push $pf.FullName $pdest $pf.Name $pf.Length
                [System.Windows.Forms.Application]::DoEvents()
                if($script:StopRequested){break}
            }
            if($script:StopRequested){Add-Log (T "log_paste_cancelled") "Yellow";$script:StopRequested=$false}
            else{Add-Log (T "log_extracted_to_android" @($adbDest)) "Green"}
            Refresh-Panel "ADB"
        }
    }finally{
        Remove-Item -LiteralPath $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Pack-Action{
    $lv=Get-ALV;$items=Get-SelItems $lv
    if($items.Count -eq 0){Add-Log (T "msg_no_items_for_pack") "Red";return}
    if($lv -ne $lvPC){Add-Log (T "msg_pack_pc_only") "Red";return}
    $srcPaths=@($items|ForEach-Object{(Get-ItemTag $_).Path})
    $defName=[System.IO.Path]::GetFileName($currentLocalPath)+".7z"
    $archName=Show-AdbDialog (T "dlg_pack_archive") (T "dlg_archive_name") $defName
    if($null -eq $archName){return}
    if(-not $archName.Contains(".")){$archName+=".7z"}
    Pack-ToArchive $srcPaths $archName $currentLocalPath
    $global:SelectedPaths.Clear();Refresh-Panel "PC"}

function Open-ArchiveItem{param($lv,$item)
    $tag=[string]$item.Tag
    if(-not $tag.StartsWith("ARCH:")){return}
    $innerPath=$tag.Substring(5)
    $archPath=$script:ArchivePath
    $fn=($innerPath -split "[/\\]")[-1]
    if($fn -eq ""){Add-Log (T "msg_cannot_open_dir") "Red";return}
    $script:StopRequested=$false
    Add-Log "Opening archive item: $fn" "Blue" -Level Important
    Add-Log "Archive path: $archPath" "Gray" -Level Detailed
    Add-Log "Inner path: $innerPath" "Gray" -Level Detailed
    
    if(-not(Test-Path $env7z -ErrorAction SilentlyContinue)){
        Add-Log (T "msg_7z_not_found") "Red"
        return
    }
    
    # Создаём временный каталог
    $tmpDir=New-TmpDir
    Add-Log "Created temp dir: $tmpDir" "Gray" -Level Detailed
    
    try{
        # ИЗВЛЕКАЕМ - точно как в Copy-Action
        Set-Status "Extracting $fn from archive..."
        Extract-FromArchive $script:ArchivePath @($innerPath) $tmpDir $false
        
        # ВАЖНО: разрешаем полный путь
        $tmpDir=(Get-Item -LiteralPath $tmpDir).FullName
        Add-Log "Resolved temp dir: $tmpDir" "Gray" -Level Detailed
        
        # Ищем файл по пути внутри архива (предпочтительно) или по имени
        $tmpFile=$null
        $relInner=($innerPath -replace "/","\").TrimStart("\")
        $expectedPath=Join-Path $tmpDir $relInner
        if(Test-Path -LiteralPath $expectedPath){
            $tmpFile=$expectedPath
            Add-Log "Resolved by inner path: $tmpFile" "Green" -Level Detailed
        }else{
            $allFiles=@(Get-ChildItem -LiteralPath $tmpDir -Recurse -File -ErrorAction SilentlyContinue)
            Add-Log "Files extracted: $($allFiles.Count)" "Gray" -Level Detailed
            foreach($f in $allFiles){
                Add-Log "  Found: $($f.FullName)" "Gray" -Level Debug
                if($f.Name -eq $fn){
                    $tmpFile=$f.FullName
                    Add-Log "MATCH by name: $tmpFile" "Green" -Level Detailed
                    break
                }
            }
        }
        
        # Открываем файл
        if($tmpFile -and (Test-Path -LiteralPath $tmpFile)){
            Add-Log "File exists, opening: $tmpFile" "Green" -Level Detailed
            $ft=Get-FileType $fn
            Add-Log "File type: $ft" "Gray" -Level Detailed
            
            if($ft -eq "media"){
                Start-Process $tmpFile
                Add-Log "Opened media from archive: $fn" "Green" -Level Important
            }
            else{
                Add-Log "Opening in text editor..." "Gray" -Level Detailed
                Show-TextEditor $tmpFile "$fn [Archive]" $false "" $true $archPath $innerPath $tmpDir
                Add-Log "Text editor opened: $fn (save updates archive)" "Green" -Level Important
            }
        }else{
            Add-Log "ERROR: File not found: $tmpFile" "Red"
            if($tmpFile){Add-Log "Path exists: $(Test-Path -LiteralPath $tmpFile)" "Red" -Level Detailed}
        }
    }
    catch{
        Add-Log "ERROR in Open-ArchiveItem: $_" "Red"
    }
    finally{
        # НЕ удаляем tmpDir - файл ещё открыт в редакторе!
        # Remove-Item -LiteralPath $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}


function Preview-AdbMedia{param([string]$rp,[string]$fn,[long]$sz)
    $maxBytes=500MB
    if($sz -gt $maxBytes){
        $mb=[int]($sz/1MB)
        $r=Show-AdbDialog "Large File" "File is $mb MB (limit 500 MB). Download anyway?" $null @($fn)
        if($null -eq $r){return}}
    # Invoke-Pull runs "adb pull <remote> <dir>", which places the file at <dir>\<original name> -
    # it does not rename it, so the expected local path here must match that exactly.
    $tmp=Join-Path $env:TEMP $fn
    Invoke-Pull $rp $env:TEMP $fn $sz
    if(Test-Path -LiteralPath $tmp){Start-Process $tmp;Add-Log "Opened media: $fn" -Level Important}
    else{Add-Log "Failed to pull media: $fn" "Red"}}



$navAction={
    Add-Log ">>> navAction called" "Yellow" -Level Debug
    $lv=Get-ALV
    Add-Log "Active ListView: $(if($lv -eq $lvPC){'PC'}else{'ADB'})" "Gray" -Level Debug
    $item=Get-SelI $lv
    $itemText=if($null -ne $item){$item.Text}else{'NULL'}
    Add-Log "Selected item: $itemText" "Gray" -Level Debug
    if($null -eq $item){
        Add-Log "Item is NULL, returning" "Gray" -Level Debug
        return
    }
    $ti=Get-ItemTag $item
    $clean=$item.Text
    Add-Log "Item tag: $($item.Tag), Clean: $clean" "Gray" -Level Debug
    Add-Log "Archive path: $($script:ArchivePath)" "Gray" -Level Debug
    Add-Log "Label text: $($lbl0.Text)" "Gray" -Level Debug
    
    # ===== ПЕРВАЯ ПРОВЕРКА: Находимся ли мы ВНУТРИ архива? =====
    $lbl0=if($lv -eq $lvPC){$lblPC}else{$lblADB}
    Add-Log "Inside archive check: ArchivePath='$($script:ArchivePath)' Label='$($lbl0.Text)'" "Gray" -Level Debug
    
    if($script:ArchivePath -ne "" -and $lbl0.Text.StartsWith("[ARCH]")){
        Add-Log "!!! WE ARE INSIDE ARCHIVE !!!" "Yellow" -Level Debug

        
        # Close archive
        if($item.Tag -eq "__ARCHCLOSE__"){
            if($script:ArchiveSubDir -ne ""){
                $parts2=$script:ArchiveSubDir -split "/"
                if($parts2.Count -gt 1){$script:ArchiveSubDir=($parts2[0..($parts2.Count-2)]) -join "/"}
                else{$script:ArchiveSubDir=""}
                Refresh-ArchPanel;$lv.Focus();return
            }
            $savedArchName=$script:ArchiveName
            $script:ArchivePath=""
            if($lv -eq $lvPC){Refresh-Panel "PC"}else{Refresh-Panel "ADB"}
            if($savedArchName -and $savedArchName -ne ""){Find-Sel $lv $savedArchName}
            $lv.Focus();return
        }
        
        # Handle ARCH: prefixed items
        if(([string]$item.Tag).StartsWith("ARCH:")){
            $innerPath2=([string]$item.Tag).Substring(5)
            Add-Log "Archive item: $innerPath2" "Gray" -Level Debug
            
            # Check if directory
            $archItems2=List-Archive $script:ArchivePath $script:ArchiveSubDir
            $isArchDir2=$false
            foreach($ai2 in $archItems2){
                if($ai2.InnerPath -eq $innerPath2 -and $ai2.IsDir){
                    $isArchDir2=$true
                    break
                }
            }
            
            # If directory - navigate into it
            if($isArchDir2){
                Add-Log "Navigating into directory: $innerPath2" "Gray" -Level Debug
                $script:ArchiveSubDir=$innerPath2
                Refresh-ArchPanel;$lv.Focus();return
            }
            
            # If file - open in editor or media player
            $ft2=Get-FileType $clean
            Add-Log "Archive file type: $ft2, filename: $clean" "Gray" -Level Debug
            
            if($ft2 -eq "media" -or $ft2 -eq "text" -or $clean -match "\.(ps1|bat|cmd|sh|bash|ini|cfg|conf|log|nfo|sql|properties|gradle|cmake|makefile|dockerfile)$"){
                Add-Log "Opening archive file: $clean" "Yellow" -Level Debug
                Open-ArchiveItem $lv $item
            }
            $lv.Focus();return
        }
        
        $lv.Focus();return
    }
    
    # ===== ВТОРАЯ ПРОВЕРКА: Обработка APK/XAPK/APKS на PC (вне архива) =====
    if($lv -eq $lvPC -and $currentLocalPath -ne "DRIVES" -and -not $ti.IsDir){
        $e2=($clean -split "\.")[-1].ToLower()
        if($e2 -in @("apk","xapk","apks")){
            if($e2 -eq "xapk"){Install-XAPK $ti.Path}
            elseif($e2 -eq "apks"){Install-APKS $ti.Path}
            else{Install-APK $ti.Path}
            return
        }
    }
    
    # ===== ТРЕТЬЯ ПРОВЕРКА: Обработка обычных файлов на PC (вне архива) =====
    if($lv -eq $lvPC -and $currentLocalPath -ne "DRIVES" -and -not $ti.IsDir){
        $ft=Get-FileType $clean
        $dot2=$clean.LastIndexOf(".");$ext2=if($dot2 -ge 0){$clean.Substring($dot2+1).ToLower()}else{""}
        
        # Archive files - open archive
        if($ft -eq "arch"){
            $resolved=Get-ArchiveFirstPart $ti.Path
            if($resolved -ne $ti.Path){
                Add-Log (T "log_multipart_first_part" @((Split-Path $resolved -Leaf))) -Level Detailed
                Open-Archive $resolved $true
            }else{
                Open-Archive $ti.Path $true
            }
            $lv.Focus();return
        }
        
        # Executable files - run
        if($ft -eq "exec"){
            Open-File $ti.Path "run";$lv.Focus();return
        }
        
        # Text files - open
        if($ft -in @("text")){
            Open-File $ti.Path "open";$lv.Focus();return
        }
        
        # Media files - open
        if($ft -eq "media"){
            Open-File $ti.Path "open";$lv.Focus();return
        }
    }
    
    # ===== ЧЕТВЁРТАЯ ПРОВЕРКА: Media preview на ADB (вне архива) =====
    if($lv -eq $lvADB -and -not $ti.IsDir){
        $ft=Get-FileType $clean
        
        # Media files - preview
        if($ft -eq "media"){
            $szRaw=(& "$envAdb" shell stat -c "%s" "`"$($ti.Path)`"" 2>&1) -replace "`r",""
            $sz=if($szRaw -match "^[0-9]+$"){[long]$szRaw}else{0L}
            Preview-AdbMedia $ti.Path $clean $sz;$lv.Focus();return
        }
        
        # Archive files - pull and open
        if($ft -eq "arch"){
            $tmp=Join-Path $env:TEMP $clean
            Set-Status "Pulling archive..."
            & "$envAdb" pull "`"$($ti.Path)`"" "`"$tmp`"" 2>&1 | Out-Null
            if(Test-Path -LiteralPath $tmp){
                $firstPart=Get-ArchiveFirstPart $tmp
                $script:ArchivePath=$firstPart;$script:ArchiveIsPC=$false
                $script:ArchiveName=Split-Path $firstPart -Leaf
                $script:ArchiveSubDir=""
                Refresh-ArchPanel;$lv.Focus();return
            }
        }
    }
    
    # ===== ПЯТАЯ ПРОВЕРКА: Навигация вверх =====
    if($ti.Path -eq "__GOUP__"){
        if($lv -eq $lvPC){
            $fe=Split-Path $currentLocalPath -Leaf
            $pp=Split-Path $currentLocalPath -Parent
            $script:currentLocalPath=if(!$pp -or $pp -eq $currentLocalPath){"DRIVES"}else{$pp}
            Refresh-Panel "PC"
            if($fe){Find-Sel $lvPC $fe}
        }
        else{
            $parts=$currentAdbPath.TrimEnd("/").Split("/")
            $fe=$parts[-1]
            $script:currentAdbPath=($parts[0..($parts.Count-2)] -join "/")
            if(!$currentAdbPath){$script:currentAdbPath="/"}
            Refresh-Panel "ADB"
            if($fe){Find-Sel $lvADB $fe}
        }
    }
    # ===== ШЕСТАЯ ПРОВЕРКА: Навигация в папку =====
    else{
        if($lv -eq $lvPC){
            if($currentLocalPath -eq "DRIVES"){
                $script:currentLocalPath=$ti.Path
                Refresh-Panel "PC"
            }
            elseif($ti.IsDir){
                $script:currentLocalPath=$ti.Path
                Refresh-Panel "PC"
            }
        }
        else{
            if($ti.IsDir){
                $script:currentAdbPath=$ti.Path
                Refresh-Panel "ADB"
            }
        }
    }
    $lv.Focus()
    Add-Log "<<< navAction completed" "Yellow" -Level Debug
}





function Search-Action{
    $lv=Get-ALV;$script:SearchIsPC=($lv -eq $lvPC);$script:SearchStop=$false
    $query=Show-AdbDialog (T "dlg_search_title") (T "dlg_search_prompt") "*"
    if($null -eq $query -or $query.Trim() -eq ""){return}
    $sw2=New-Object System.Windows.Forms.Form;$sw2.Text="$(T 'dlg_search_title'): $query";$sw2.Size="740,540"
    $sw2.BackColor=$bgForm;$sw2.ForeColor=$clrText;$sw2.StartPosition="CenterParent";$sw2.FormBorderStyle="Sizable"
    $topP=New-Object System.Windows.Forms.Panel;$topP.Dock="Top";$topP.Height=32;$topP.BackColor=[System.Drawing.Color]::FromArgb(30,30,36);$sw2.Controls.Add($topP)
    $sLbl=New-Object System.Windows.Forms.Label;$sLbl.Location="8,7";$sLbl.Size="540,20";$sLbl.ForeColor=$clrDim;$topP.Controls.Add($sLbl)
    $bStop=New-Object System.Windows.Forms.Button;$bStop.Text=(T "btn_stop");$bStop.Location="580,4";$bStop.Size="80,24"
    $bStop.FlatStyle="Flat";$bStop.ForeColor=$clrText;$bStop.BackColor=[System.Drawing.Color]::FromArgb(48,48,56)
    $bStop.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80)
    $bStop.Add_Click({$script:SearchStop=$true;$bStop.Enabled=$false});$topP.Controls.Add($bStop)
    $sLV=New-Object System.Windows.Forms.ListView;$sLV.Dock="Fill";$sLV.View="Details";$sLV.FullRowSelect=$true
    $sLV.BackColor=$bgInact;$sLV.ForeColor=$clrText;$sLV.Font=$fntItem;$sLV.BorderStyle="None"
    $sLV.Columns.Add((T "col_path"),590)|Out-Null;$sLV.Columns.Add((T "col_size"),80)|Out-Null
    $sw2.Controls.Add($sLV);$sLV.BringToFront()
    $script:SearchSLV=$sLV;$script:SearchSW=$sw2
    $sw2.Show();$sLbl.Text="  $(T 'st_searching_for' @($query))...";$form.Update()
    $cnt=0
    if($script:SearchIsPC){
        $root=if($currentLocalPath -eq "DRIVES"){"C:\"}else{$currentLocalPath}
        try{
            Get-ChildItem $root -Recurse -Filter $query -ErrorAction SilentlyContinue|ForEach-Object{
                if($script:SearchStop){return}
                $szS=if($_.PSIsContainer){"<Dir>"}else{Format-Bytes $_.Length}
                $li=New-Object System.Windows.Forms.ListViewItem($_.FullName);$li.SubItems.Add($szS)|Out-Null;$li.Tag=$_.FullName
                $sLV.Items.Add($li)|Out-Null;$cnt++;$sLbl.Text="  $(T 'st_found_items' @($cnt))..."
                [System.Windows.Forms.Application]::DoEvents()}
        }catch{}
    }else{
        $rawS=& "$envAdb" shell ('find '+(Escape-AdbShell $currentAdbPath)+' -name '+(Escape-AdbShell $query)+' 2>/dev/null') 2>&1
        foreach($line in ($rawS -split "`n")){
            if($script:SearchStop){break}
            $pp=($line -replace "`r","").Trim();if(-not $pp){continue}
            $li=New-Object System.Windows.Forms.ListViewItem($pp);$li.SubItems.Add("")|Out-Null;$li.Tag=$pp
            $sLV.Items.Add($li)|Out-Null;$cnt++;$sLbl.Text="  $(T 'st_found_items' @($cnt))..."
            [System.Windows.Forms.Application]::DoEvents()}
    }
    $bStop.Enabled=$false
    $sLbl.Text="  $(T 'st_found_items_done' @($cnt))"
    $sLV.Add_DoubleClick({
        if($script:SearchSLV.SelectedItems.Count -eq 0){return}
        $selPath=$script:SearchSLV.SelectedItems[0].Tag
        if($script:SearchIsPC){
            $script:currentLocalPath=Split-Path $selPath -Parent
            Refresh-Panel "PC";$form.Activate();$lvPC.Focus();Find-Sel $lvPC (Split-Path $selPath -Leaf)
        }else{
            $script:currentAdbPath=(Split-Path $selPath -Parent) -replace "\\","/"
            Refresh-Panel "ADB";$form.Activate();$lvADB.Focus();Find-Sel $lvADB (Split-Path $selPath -Leaf)
        }
        $script:SearchSW.Close()
    })
}

function Ctx-Run{Open-File $script:CtxPath "run"}
function Ctx-Edit{Open-File $script:CtxPath "edit"}
function Ctx-EditAdb{Edit-AdbFile $script:CtxPath(Split-Path $script:CtxPath -Leaf)}
function Ctx-Open{Open-File $script:CtxPath "open"}
function Ctx-Apk{
    $p=$script:CtxPath;$e=($p -split "\.")[-1].ToLower()
    if($e -eq "xapk"){Install-XAPK $p}
    elseif($e -eq "apks"){Install-APKS $p}
    else{Install-APK $p}}
# FIX Copy: CtxLVRef set before Show(); Closed fires AFTER click handler, so ref still valid

function Ctx-Unpack{
    $lv=$script:CtxLVRef;$item=$script:CtxItem
    if($null -ne $item){
        # For multipart archives - always start from first part
        $ti=Get-ItemTag $item
        $firstPath=Get-ArchiveFirstPart $ti.Path
        if($firstPath -ne $ti.Path){
            Add-Log (T "log_multipart_first_part" @((Split-Path $firstPath -Leaf))) -Level Detailed
            # Create a fake item with first part path
            $fakeItem=New-Object System.Windows.Forms.ListViewItem
            $fakeItem.Tag="FILE:$firstPath"
            Unpack-Action $lv $fakeItem
        }else{Unpack-Action $lv $item}}}
function Ctx-Pack{Pack-Action}
function Ctx-Copy{
    $lv=$script:CtxLVRef
    $its=if($null -ne $lv){Get-SelItems $lv}else{@()}
    if($its.Count -eq 0 -and $null -ne $script:CtxItem){$its=@($script:CtxItem)}
    $global:ClipboardItems=@();$global:ClipboardIsAdb=(-not $script:CtxIsPC)
    $fl=New-Object System.Collections.Specialized.StringCollection
    foreach($it in ($its|Where-Object{$_.Tag -ne "__GOUP__"})){
        $ti=Get-ItemTag $it
        [void]$global:SelectedPaths.Add($ti.Path)
        $global:ClipboardItems+=@{Path=$ti.Path;IsDir=$ti.IsDir}
        $fl.Add($ti.Path)|Out-Null}
    if($null -ne $lv){$lv.Invalidate()}
    if($script:CtxIsPC -and $fl.Count -gt 0){
        try{[System.Windows.Forms.Clipboard]::SetFileDropList($fl);Add-Log "Copied to clipboard: $($global:ClipboardItems.Count) file(s)" -Level Important}
        catch{Add-Log "Copied: $($global:ClipboardItems.Count) item(s)" -Level Important}}
    else{Add-Log "Copied: $($global:ClipboardItems.Count) item(s)" -Level Important}}
function Ctx-Paste{
    $isPC=$script:CtxIsPC
    $script:StopRequested=$false
    foreach($ci in $global:ClipboardItems){$fn=Split-Path $ci.Path -Leaf
        if($global:ClipboardIsAdb -and $isPC){
            # ADB -> PC
            $raw=(& "$envAdb" shell stat -c "%s" "`"$($ci.Path)`"" 2>&1) -replace "`r","";$sz=if($raw -match "^[0-9]+$"){[long]$raw}else{0L}
            Invoke-Pull $ci.Path $currentLocalPath $fn $sz}
        elseif(-not $global:ClipboardIsAdb -and -not $isPC){
            # PC -> ADB
            Invoke-Push $ci.Path "$($currentAdbPath.TrimEnd("/"))/$fn" $fn (Get-LocalSize $ci.Path)}
        elseif($global:ClipboardIsAdb -and -not $isPC){
            # ADB -> ADB (same side)
            $dest="$($currentAdbPath.TrimEnd("/"))/$fn"
            if($dest -ne $ci.Path){
                Set-Status "$(T 'st_copying_on_device'): $fn...";$form.Update()
                if($ci.IsDir){& "$envAdb" shell "cp -r '$($ci.Path)' '$dest'" 2>&1 | Out-Null}
                else{& "$envAdb" shell "cp '$($ci.Path)' '$dest'" 2>&1 | Out-Null}
                Add-Log "$(T 'log_copied_on_device'): $fn" "Green" -Level Important
            }else{Add-Log "$(T 'log_skipped_same_path'): $fn" "Red"}}
        else{
            # PC -> PC (same side)
            $dest=Join-Path $currentLocalPath $fn
            if($dest -ne $ci.Path){
                try{if($ci.IsDir){Copy-Item -LiteralPath $ci.Path -Destination $dest -Recurse -Force}else{Copy-Item -LiteralPath $ci.Path -Destination $dest -Force};Add-Log "$(T 'log_copied'): $fn" "Green" -Level Important}
                catch{Add-Log "$(T 'log_copy_failed'): $_" "Red"}
            }else{Add-Log "$(T 'log_skipped_same_path'): $fn" "Red"}}
        if($script:StopRequested){break}}
    $global:ClipboardItems=@();$global:SelectedPaths.Clear();Refresh-Panel "PC";Refresh-Panel "ADB"
    if($script:StopRequested){Add-Log (T "log_paste_cancelled") "Yellow";$script:StopRequested=$false}
    else{Add-Log (T "log_paste_done") -Level Important}}
Add-Type -TypeDefinition @"
using System.Drawing; using System.Windows.Forms;
public class DarkMenuRenderer:ToolStripProfessionalRenderer{
    public DarkMenuRenderer():base(new DarkColorTable()){}
    protected override void OnRenderImageMargin(ToolStripRenderEventArgs e){}
    protected override void OnRenderMenuItemBackground(ToolStripItemRenderEventArgs e){
        var g=e.Graphics;var r=new Rectangle(0,0,e.Item.Width,e.Item.Height);
        Color bg=(e.Item.Selected&&e.Item.Enabled)?Color.FromArgb(42,100,175):Color.FromArgb(44,44,52);
        g.FillRectangle(new SolidBrush(bg),r);}}
public class DarkColorTable:ProfessionalColorTable{
    public override Color MenuBorder{get{return Color.FromArgb(70,70,80);}}
    public override Color ToolStripDropDownBackground{get{return Color.FromArgb(44,44,52);}}
    public override Color ImageMarginGradientBegin{get{return Color.FromArgb(44,44,52);}}
    public override Color ImageMarginGradientMiddle{get{return Color.FromArgb(44,44,52);}}
    public override Color ImageMarginGradientEnd{get{return Color.FromArgb(44,44,52);}}}
"@ -ReferencedAssemblies "System.Windows.Forms","System.Drawing" -ErrorAction SilentlyContinue
$ctxMenu=New-Object System.Windows.Forms.ContextMenuStrip
try{$ctxMenu.Renderer=New-Object DarkMenuRenderer}catch{}
$ctxMenu.BackColor=[System.Drawing.Color]::FromArgb(44,44,52);$ctxMenu.ForeColor=$clrText;$ctxMenu.ShowImageMargin=$false
$ctxMenu.Add_Closed({try{$lvPC.Invalidate()}catch{};try{$lvADB.Invalidate()}catch{}})

function Add-MI{param([string]$t2,[string]$fn,[bool]$en=$true)
    $mi=New-Object System.Windows.Forms.ToolStripMenuItem($t2)
    $mi.Enabled=$en;$mi.BackColor=[System.Drawing.Color]::FromArgb(44,44,52)
    $mi.ForeColor=if($en){$clrText}else{[System.Drawing.Color]::FromArgb(90,88,84)}
    if($en){$mi.Add_Click([scriptblock]::Create("$fn"))}
    $ctxMenu.Items.Add($mi)|Out-Null}
function Show-CtxMenu{param($lv)
    if($script:AppMode -and $lv -eq $lvADB){Show-AppCtxMenu $lv;return}
    $ctxMenu.Items.Clear()
    $mp=[System.Windows.Forms.Control]::MousePosition;$cp=$lv.PointToClient($mp)
    $hit=$lv.HitTest($cp.X,$cp.Y)
    if($null -ne $hit.Item){$hit.Item.Selected=$true;$hit.Item.Focused=$true;$lv.Focus()}
    $isPC=($lv -eq $lvPC);$hasClip=$global:ClipboardItems.Count -gt 0
    $script:CtxLVRef=$lv;$script:CtxIsPC=$isPC
    $item=Get-SelI $lv
    if($null -eq $item -or $item.Tag -eq "__GOUP__"){
        $script:CtxItem=$null;$script:CtxPath="";Add-MI (T "ctx_paste") "Ctx-Paste" $hasClip;$ctxMenu.Show($mp);return}
    $ti=Get-ItemTag $item;$isDir=$ti.IsDir;$ft=if(-not $isDir){Get-FileType $item.Text}else{"dir"}
    $script:CtxItem=$item;$script:CtxPath=$ti.Path;$script:CtxIsDir=$isDir
    # Snapshot items NOW before menu shows - Ctx-Copy will use this
    $script:CtxSnap=@(Get-SelItems $lv);if($script:CtxSnap.Count -eq 0){$script:CtxSnap=@($item)}
    $lv.Invalidate()
    Add-MI (T "ctx_run")                    "Ctx-Run"     ($ft -eq "exec" -and $isPC)
    Add-MI (T "ctx_edit_builtin")        "Ctx-Edit"    (-not $isDir -and $isPC)
    Add-MI (T "ctx_edit_pullpush")  "Ctx-EditAdb" (-not $isDir -and -not $isPC)
    Add-MI (T "ctx_open_default")      "Ctx-Open"    (-not $isDir -and $isPC)
    Add-MI (T "ctx_install_apk")  "Ctx-Apk"     ($ft -eq "apk" -and $isPC)
    $ctxMenu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))|Out-Null
    # Archive options
    $isArch=($ft -eq "arch" -and $isPC)
    Add-MI (T "ctx_unpack")   "Ctx-Unpack"  $isArch
    Add-MI (T "ctx_pack")    "Ctx-Pack"    ($isPC -and $global:SelectedPaths.Count -gt 0)
    $ctxMenu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))|Out-Null
    Add-MI (T "ctx_copy") "Ctx-Copy"   $true
    Add-MI (T "ctx_paste")                   "Ctx-Paste"  $hasClip
    $ctxMenu.Show($mp)}
$lvPC.Add_MouseUp({param($s,$e);if($e.Button -eq "Right"){Show-CtxMenu $lvPC}})
$lvADB.Add_MouseUp({param($s,$e);if($e.Button -eq "Right"){Show-CtxMenu $lvADB}})

function Rename-Action{
    $lv=Get-ALV
    $item=Get-SelI $lv
    if($null -eq $item -or $item.Tag -eq "__GOUP__"){return}
    $clean=$item.Text
    $new=Show-AdbDialog (T "dlg_rename_title") (T "dlg_new_name") $clean
    if($null -ne $new -and $new -ne $clean){
        $ti=Get-ItemTag $item
        if($lv -eq $lvPC){
            Rename-Item $ti.Path $new -ErrorAction SilentlyContinue
            Refresh-Panel "PC"
            Add-Log (T "log_renamed" @($clean,$new)) -Level Important
        }else{
            $rnDst="$($currentAdbPath.TrimEnd('/'))/$new"
            & "$envAdb" shell "mv '$($ti.Path)' '$rnDst'" 2>&1 | Out-Null
            Refresh-Panel "ADB"
            Add-Log (T "log_renamed" @($clean,$new)) -Level Important
        }
    }
    $lv.Focus()
}

function Copy-Action{
    $script:StopRequested=$false
    $lv0=Get-ALV
    $lbl0=if($lv0 -eq $lvPC){$lblPC}else{$lblADB}
    if($script:ArchivePath -ne "" -and $lbl0.Text.StartsWith("[ARCH]")){
        $lv2=Get-ALV
        $items2=Get-SelItems $lv2
        $innerPaths2=@()
        if($items2.Count -gt 0){
            $innerPaths2=@($items2|Where-Object{([string]$_.Tag).StartsWith("ARCH:")}|ForEach-Object{([string]$_.Tag).Substring(5)})
        # Detect if any selected item is a directory
        $hasDir2=$items2|Where-Object{([string]$_.Tag).StartsWith("ARCH:")}|ForEach-Object{
            $ip=([string]$_.Tag).Substring(5)
            $archItems2b=List-Archive $script:ArchivePath $script:ArchiveSubDir
            $archItems2b|Where-Object{$_.InnerPath -eq $ip -and $_.IsDir}}
        $flatExtract2=($hasDir2.Count -eq 0)
        }
        $dlg=Show-ExtractDialog $script:ArchiveName
        if($dlg.Result -eq "Cancel"){return}
        if($dlg.Result -eq "Yes"){
            Extract-FromArchive $script:ArchivePath $innerPaths2 $dlg.PCPath $flatExtract2
            Refresh-Panel "PC"
        }else{
            # Android: extract to tmp, push content directly to currentAdbPath
            $tmpDir3=New-TmpDir
            try{
                Extract-FromArchive $script:ArchivePath $innerPaths2 $tmpDir3 $flatExtract2
                $tmpDir3=(Get-Item -LiteralPath $tmpDir3).FullName
                $adbBase3=$currentAdbPath.TrimEnd("/")
                $allDirs3=@(Get-ChildItem -LiteralPath $tmpDir3 -Recurse -Directory|Sort-Object FullName)
                $allFiles3=@(Get-ChildItem -LiteralPath $tmpDir3 -Recurse -File)
                $total3=$allDirs3.Count+$allFiles3.Count;$idx3=0
                foreach($pd3 in $allDirs3){
                    $idx3++
                    $rel3=$pd3.FullName.Substring($tmpDir3.Length+1) -replace "\\","/"
                    AdbMkdir "$adbBase3/$rel3"
                    Set-Status "$(T 'st_creating_dir') ($idx3/$total3): $($pd3.Name)" "Blue"
                }
                foreach($pf3 in $allFiles3){
                    $idx3++
                    $rel3=$pf3.FullName.Substring($tmpDir3.Length+1) -replace "\\","/"
                    $pdest3="$adbBase3/$rel3"
                    Set-Status "$(T 'st_pushing') ($idx3/$total3): $($pf3.Name)" "Blue"
                    Invoke-Push $pf3.FullName $pdest3 $pf3.Name $pf3.Length
                    [System.Windows.Forms.Application]::DoEvents()
                    if($script:StopRequested){break}
                }
                if($script:StopRequested){Add-Log (T "log_paste_cancelled") "Yellow";$script:StopRequested=$false}
                else{Add-Log (T "log_extracted_to_android" @($adbBase3)) "Green"}
                Refresh-Panel "ADB"
            }finally{
                Remove-Item -LiteralPath $tmpDir3 -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        $global:SelectedPaths.Clear()
        Refresh-ArchPanel
        return
    }
    $lv=Get-ALV
    $items=Get-SelItems $lv
    if($items.Count -eq 0){return}
    $names=@($items|ForEach-Object{$_.Text})
    if($null -eq (Show-AdbDialog (T "dlg_confirm_copy") (T "dlg_copy_items_q") $null $names)){return}
    $script:StopRequested=$false
    foreach($it in $items){
        $ti=Get-ItemTag $it
        if($lv -eq $lvPC){
            $adbT=$currentAdbPath.TrimEnd("/")
            Invoke-Push $ti.Path "$adbT/$($it.Text)" $it.Text (Get-LocalSize $ti.Path)
        }else{
            $raw=(& "$envAdb" shell stat -c "%s" "`"$($ti.Path)`"" 2>&1) -replace "`r",""
            $sz=if($raw -match "^[0-9]+$"){[long]$raw}else{0L}
            Invoke-Pull $ti.Path $currentLocalPath $it.Text $sz
        }
        if($script:StopRequested){break}
    }
    $global:SelectedPaths.Clear()
    Refresh-Panel "PC"
    Refresh-Panel "ADB"
    if($script:StopRequested){Add-Log (T "log_paste_cancelled") "Yellow";$script:StopRequested=$false}
    else{Add-Log (T "log_copy_done") -Level Important}
    $lv.Focus()
}

function Move-Action{
    $lv=Get-ALV
    $item=Get-SelI $lv
    if($null -eq $item -or $item.Tag -eq "__GOUP__"){return}
    $clean=$item.Text
    $new=Show-AdbDialog (T "dlg_move_rename_title") (T "dlg_new_name") $clean
    if($null -ne $new){
        $ti=Get-ItemTag $item
        if($lv -eq $lvPC){
            Rename-Item $ti.Path $new -ErrorAction SilentlyContinue
            Refresh-Panel "PC"
        }else{
            $mvDst="$($currentAdbPath.TrimEnd('/'))/$new"
            & "$envAdb" shell "mv '$($ti.Path)' '$mvDst'" 2>&1 | Out-Null
            Refresh-Panel "ADB"
        }
    }
    $lv.Focus()
}


function Edit-Action{
    $lv=Get-ALV
    $item=Get-SelI $lv
    if($null -eq $item -or $item.Tag -eq "__GOUP__"){return}
    $ti=Get-ItemTag $item
    
    # Check if inside archive
    $lbl0=if($lv -eq $lvPC){$lblPC}else{$lblADB}
    if($script:ArchivePath -ne "" -and $lbl0.Text.StartsWith("[ARCH]")){
        # Inside archive - use Open-ArchiveItem
        if(([string]$item.Tag).StartsWith("ARCH:")){
            Open-ArchiveItem $lv $item
        }
        $lv.Focus()
        return
    }
    
    if($lv -eq $lvPC){Open-File $ti.Path "edit"}
    else{Edit-AdbFile $ti.Path $item.Text}
    $lv.Focus()
}


function NewDir-Action{
    $lv=Get-ALV
    $new=Show-AdbDialog (T "dlg_new_folder_title") (T "dlg_folder_name") (T "dlg_new_folder_default")
    if($null -ne $new){
        if($lv -eq $lvPC){
            New-Item -ItemType Directory -Path (Join-Path $currentLocalPath $new) -ErrorAction SilentlyContinue|Out-Null
            Refresh-Panel "PC"
        }else{
            & "$envAdb" shell ('mkdir -p '+(Escape-AdbShell "$currentAdbPath/$new")) 2>&1 | Out-Null
            Refresh-Panel "ADB"
        }
        Add-Log (T "log_created" @($new)) -Level Important
    }
    $lv.Focus()
}

function Delete-Action{
    $lv=Get-ALV
    $items=Get-SelItems $lv
    if($items.Count -eq 0){return}
    $names=@($items|ForEach-Object{$_.Text})
    if($null -eq (Show-AdbDialog (T "dlg_confirm_delete") (T "dlg_delete_items_q") $null $names)){return}
    foreach($it in $items){
        $ti=Get-ItemTag $it
        if($lv -eq $lvPC){Remove-Item -LiteralPath $ti.Path -Recurse -Force -ErrorAction SilentlyContinue}
        else{& "$envAdb" shell "rm -rf '$($ti.Path)'" 2>&1 | Out-Null}
    }
    $global:SelectedPaths.Clear()
    Refresh-Panel "PC"
    Refresh-Panel "ADB"
    Add-Log (T "log_deleted" @($names -join ', ')) -Level Important
    $lv.Focus()
}

function Enter-AndroidFolder {
    param([string]$Path)
    $script:currentAdbPath=$Path
    $script:AppMode=$false
    $script:AppCategory="Select Apps"
    $script:AppFilter=""
    $script:AppFilterPhrases=@()
    $script:AppFilterMode="All"
    $global:SelectedPaths.Clear()
    $appFilterStatus.Text="";$appFilterPhrasesStatus.Text="";$appFilterModeStatus.Text=""
    $appFilterStatus.Visible=$false;$appFilterPhrasesStatus.Visible=$false;$appFilterModeStatus.Visible=$false
    if($appNamesBox){$appNamesBox.Checked=$false;$appNamesBox.Visible=$false};if($appNamesBtn){$appNamesBtn.Visible=$false};if($appResetBtn){$appResetBtn.Visible=$false}
    $script:AppNamesCancel=$true
    $script:AppNamesBuilding=$false
    $script:AppNamesTotal=0;$script:AppNamesRead=0
    $script:AppCategoryChanging=$true
    try{$appCatBox.SelectedItem="Select Apps"}finally{$script:AppCategoryChanging=$false}
    Refresh-Panel "ADB"
    $lvADB.Focus()
}
function Go-Data{Enter-AndroidFolder "/storage/emulated/0/Android/data"}
function Go-Obb{Enter-AndroidFolder "/storage/emulated/0/Android/obb"}
function Show-Help{
    $d=New-Object System.Windows.Forms.Form
    $d.Text="Quas ADB Commander v10.5 - $(T 'hlp_title_suffix')"
    $d.Size="1020,680";$d.MinimumSize="900,600"
    $d.BackColor=$bgForm;$d.ForeColor=$clrText
    $d.FormBorderStyle="Sizable";$d.StartPosition="CenterParent";$d.KeyPreview=$true
    $d.GetType().GetProperty("DoubleBuffered",[System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).SetValue($d,$true,$null)
    $pnl=New-Object System.Windows.Forms.TableLayoutPanel
    $pnl.Dock="Fill";$pnl.ColumnCount=2;$pnl.RowCount=1
    $pnl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent,50)))|Out-Null
    $pnl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent,50)))|Out-Null
    $d.Controls.Add($pnl)
    $btnClose=New-Object System.Windows.Forms.Button
    $btnClose.Text="$(T 'btn_close')  [Esc]";$btnClose.Size="120,28";$btnClose.FlatStyle="Flat"
    $btnClose.ForeColor=$clrText;$btnClose.BackColor=[System.Drawing.Color]::FromArgb(48,48,56)
    $btnClose.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(70,70,80)
    $btnClose.Dock="Bottom";$btnClose.DialogResult="OK"
    $d.Controls.Add($btnClose)
    $d.AcceptButton=$btnClose;$d.CancelButton=$btnClose
    $mkRtb={
        $r=New-Object System.Windows.Forms.RichTextBox
        $r.Dock="Fill";$r.ReadOnly=$true;$r.BorderStyle="None"
        $r.BackColor=$bgForm;$r.ForeColor=$clrText
        $r.Font=New-Object System.Drawing.Font("Consolas",9.5)
        $r.ScrollBars="Vertical";$r.WordWrap=$false;$r.DetectUrls=$true
        $r.Add_LinkClicked({param($s,$ev)[System.Diagnostics.Process]::Start($ev.LinkText)})
        return $r}
    $L=&$mkRtb;$R=&$mkRtb
    $pnl.Controls.Add($L,0,0);$pnl.Controls.Add($R,1,0)
    $cH=[System.Drawing.Color]::FromArgb(78,201,176)
    $cK=[System.Drawing.Color]::FromArgb(156,220,254)
    $cV=[System.Drawing.Color]::FromArgb(210,208,202)
    $cD=[System.Drawing.Color]::FromArgb(150,148,142)
    $cU=[System.Drawing.Color]::FromArgb(86,156,214)
    $cW=[System.Drawing.Color]::FromArgb(220,160,50)
    $cG=[System.Drawing.Color]::FromArgb(100,200,100)
    $fB=New-Object System.Drawing.Font("Consolas",10,[System.Drawing.FontStyle]::Bold)
    $fN=New-Object System.Drawing.Font("Consolas",9.5)
    $SH={param($rtb,[string]$s)
        $rtb.SelectionFont=$fB;$rtb.SelectionColor=$cH
        $rtb.AppendText("`r`n $s`r`n")
        $rtb.SelectionFont=$fN;$rtb.SelectionColor=$cD
        $rtb.AppendText(" ------------------------------------------`r`n")}
    $KV={param($rtb,[string]$k,[string]$v)
        $rtb.SelectionFont=$fN;$rtb.SelectionColor=$cK
        $rtb.AppendText((" {0,-17}"-f $k))
        $rtb.SelectionColor=$cV;$rtb.AppendText("$v`r`n")}
    # Wider key column for the right-side Application Manager section.
    $KVR={param($rtb,[string]$k,[string]$v)
        $rtb.SelectionFont=$fN;$rtb.SelectionColor=$cK
        $rtb.AppendText((" {0,-25}"-f $k))
        $rtb.SelectionColor=$cV;$rtb.AppendText("$v`r`n")}
    $NN={param($rtb,[string]$s="",[System.Drawing.Color]$c=$cD)
        $rtb.SelectionFont=$fN;$rtb.SelectionColor=$c
        $rtb.AppendText(" $s`r`n")}
    # LEFT
    $L.SelectionFont=New-Object System.Drawing.Font("Consolas",12,[System.Drawing.FontStyle]::Bold)
    $L.SelectionColor=[System.Drawing.Color]::FromArgb(212,188,82)
    $L.AppendText(" Quas ADB Commander v10.5`r`n")
    $L.SelectionFont=$fN;$L.SelectionColor=$cD
    $L.AppendText(" $(T 'hlp_subtitle')`r`n`n")
    $L.AppendText(" $(T 'hlp_credits1')`r`n")
    $L.AppendText(" $(T 'hlp_credits2')`r`n")
    &$SH $L (T "hlp_h_navigation")
    &$KV $L "Tab"            (T "hlp_nav_tab")
    &$KV $L "Enter/DblClick" (T "hlp_nav_enter")
    &$KV $L "Space"          (T "hlp_nav_space")
    &$KV $L "* (Numpad)"     (T "hlp_nav_star")
    &$KV $L "Alt+X"          (T "hlp_nav_altx")
    &$KV $L "F9"             (T "hlp_nav_f9")
    &$KV $L "F10"            (T "hlp_nav_f10")
     &$KV $L "F12"            (T "hlp_nav_f12")
    &$SH $L (T "hlp_h_fileops")
    &$KV $L "F2"             (T "hlp_fo_f2")
    &$KV $L "F3"             (T "hlp_fo_f3")
    &$KV $L "F4"             (T "hlp_fo_f4")
    &$KV $L "F5"             (T "hlp_fo_f5")
    &$KV $L "F6"             (T "hlp_fo_f6")
    &$KV $L "F7"             (T "hlp_fo_f7")
    &$KV $L "F8 / Delete"    (T "hlp_fo_f8")
    &$KV $L (T "btn_stop")   (T "hlp_fo_stop")
    &$SH $L (T "hlp_h_editor")
    &$KV $L "Ctrl+S / F2"    (T "hlp_ed_save")
    &$KV $L "Esc"            (T "hlp_ed_esc")
    &$KV $L (T "hlp_ed_wrapbtn") (T "hlp_ed_wrap")
    &$KV $L (T "hlp_ed_syntaxbtn") (T "hlp_ed_syntax")
    &$NN $L (T "hlp_ed_star_note")
    &$NN $L (T "hlp_ed_search_note")
    &$KV $L "< >"            (T "hlp_ed_prevnext")
    &$NN $L (T "hlp_ed_rmb")
    &$NN $L ""
    &$NN $L (T "hlp_ed_syntax_auto") $cW
    $L.SelectionColor=$cG;$L.AppendText(" ps1 bat cmd sh ini cfg log nfo`r`n")
    &$SH $L (T "hlp_h_ctxmenu")
    &$KV $L (T "ctx_run")           (T "hlp_ctx_run")
    &$KV $L (T "ctx_edit_builtin")  (T "hlp_ctx_edit_builtin")
    &$KV $L (T "ctx_edit_pullpush") (T "hlp_ctx_edit_pullpush")
    &$KV $L (T "ctx_open_default")  (T "hlp_ctx_open_default")
    &$KV $L (T "ctx_install_apk")   (T "hlp_ctx_install_apk")
    &$KV $L (T "ctx_copy")          (T "hlp_ctx_copy")
    &$KV $L (T "ctx_paste")         (T "hlp_ctx_paste")
    &$KV $L (T "ctx_unpack")        (T "hlp_ctx_unpack")
    &$KV $L (T "ctx_pack")          (T "hlp_ctx_pack")

    &$SH $L (T "hlp_h_archive")
    &$KV $L "Enter/DblClick"  (T "hlp_ar_browse")
    &$KV $L (T "hlp_ar_f4key")   (T "hlp_ar_f4")
    &$KV $L (T "hlp_ar_f5files") (T "hlp_ar_f5files_v")
    &$KV $L (T "hlp_ar_f5folder") (T "hlp_ar_f5folder_v")
    &$KV $L (T "hlp_ar_starf5")  (T "hlp_ar_starf5_v")
    &$KV $L (T "hlp_ar_closearch") (T "hlp_ar_closearch_v")
    &$NN $L ""
    &$NN $L (T "hlp_ar_rmb_unpack")
    &$NN $L (T "hlp_ar_rmb_pack")
    &$NN $L ""
    &$NN $L (T "hlp_ar_formats") $cW
    $L.SelectionColor=$cG;$L.AppendText(" zip 7z rar gz tar bz2 xz cab iso tgz`r`n")
    &$SH $L (T "hlp_h_multipart")
    &$KV $L ".7z.001 / .002 / .1 / .2"   (T "hlp_mp_7z")
    &$KV $L ".part1.rar / ..." (T "hlp_mp_rar")
    &$KV $L ".z01 / .z02"      (T "hlp_mp_zip")
    &$KV $L ".001 / .002"      (T "hlp_mp_generic")
    &$NN $L ""
    &$NN $L (T "hlp_mp_note1") $cD
    &$NN $L (T "hlp_mp_note2") $cW

    # RIGHT
    &$SH $R (T "hlp_h_appmgr_list")
    &$KV $R (T "hlp_am_category_k")   (T "hlp_am_category_v")
    &$KV $R "Ctrl+F3"         (T "hlp_am_ctrlf3")
    &$KV $R (T "hlp_am_filtered_k")   (T "hlp_am_filtered_v")
    &$KV $R (T "hlp_am_filtermode_k") (T "hlp_am_filtermode_v")
    &$KV $R "A"               (T "hlp_am_a")
    &$KV $R "R"               (T "hlp_am_r")
    &$KV $R "Space"           (T "hlp_am_space")
    &$KV $R "Ctrl+A"          (T "hlp_am_ctrla")
    &$NN $R (T "hlp_am_note1") $cD
    &$NN $R (T "hlp_am_note2") $cW
    &$SH $R (T "hlp_h_appmgr_ops")
    &$KVR $R (T "hlp_op_uninstall_k") (T "hlp_op_uninstall_v")
    &$KVR $R (T "hlp_op_softuninstall_k")  (T "hlp_op_softuninstall_v")
    &$KVR $R (T "hlp_op_clear_k") (T "hlp_op_clear_v")
    &$KVR $R (T "hlp_op_disable_k") (T "hlp_op_disable_v")
    &$KVR $R (T "hlp_op_enable_k") (T "hlp_op_enable_v")
    &$KVR $R (T "hlp_op_launch_k") (T "hlp_op_launch_v")
    &$KVR $R (T "hlp_op_softstop_k")       (T "hlp_op_softstop_v")
    &$KVR $R (T "hlp_op_forcestop_k")      (T "hlp_op_forcestop_v")
    &$KVR $R (T "hlp_op_restart_k") (T "hlp_op_restart_v")
    &$KVR $R (T "hlp_op_status_k") (T "hlp_op_status_v")
    &$KVR $R (T "hlp_op_running_k") (T "hlp_op_running_v")
    &$KVR $R (T "hlp_op_save_k") (T "hlp_op_save_v")
    &$KVR $R (T "hlp_op_extract_k") (T "hlp_op_extract_v")
    &$KVR $R (T "hlp_op_fullpath_k") (T "hlp_op_fullpath_v")
    &$KVR $R (T "hlp_op_restore_k")          (T "hlp_op_restore_v")
    &$KVR $R (T "hlp_op_removeupd_k")    (T "hlp_op_removeupd_v")
    &$NN $R (T "hlp_op_note1") $cW
    &$NN $R (T "hlp_op_note2") $cD
    &$NN $R ""
    &$SH $R (T "hlp_h_tools")
    &$NN $R (T "hlp_tools_place") $cD
    $R.SelectionColor=$cG;$R.AppendText(" adb.exe  aapt2.exe  7z.exe  7z.dll`r`n")
    &$NN $R ""
    &$KV $R "-ToolsPath"  (T "hlp_tools_toolspath")
    &$KV $R "-WorkDir"    (T "hlp_tools_workdir")
    &$KV $R "-lang"       (T "hlp_tools_lang")
    &$NN $R ""
    &$NN $R (T "hlp_tools_example") $cD
    $R.SelectionColor=$cG
    $R.AppendText(" powershell -File adbcm.v10.5.ps1 -ToolsPath C:\Tools -lang RU`r`n")
    &$SH $R (T "hlp_h_media")
    &$NN $R (T "hlp_media_1")
    &$NN $R (T "hlp_media_2")
    &$NN $R (T "hlp_media_3") $cW
    &$SH $R (T "hlp_h_colors")
    $cp=@(
        @("Cyan",    (T "hlp_col_exec"),[System.Drawing.Color]::FromArgb(0,255,255)),
        @("Green",   (T "hlp_col_text"),[System.Drawing.Color]::FromArgb(0,160,0)),
        @("Blue",    (T "hlp_col_media"),[System.Drawing.Color]::FromArgb(80,150,255)),
        @("Purple",  (T "hlp_col_apk"),[System.Drawing.Color]::FromArgb(200,115,255)),
        @("Lt.Green",(T "hlp_col_arch"),[System.Drawing.Color]::FromArgb(0,255,0)),
        @("White",   (T "hlp_col_dirs"),[System.Drawing.Color]::FromArgb(255,255,255)),
        @("Yellow",  (T "hlp_col_marked"),[System.Drawing.Color]::FromArgb(255,222,40)),
        @("Gray",    (T "hlp_col_other"),[System.Drawing.Color]::FromArgb(150,148,142)))
    foreach($p in $cp){
        $R.SelectionFont=$fN;$R.SelectionColor=$p[2]
        $R.AppendText((" {0,-10}"-f $p[0]))
        $R.SelectionColor=$cD;$R.AppendText("$($p[1])`r`n")}

    &$SH $R (T "hlp_h_docs")
    $R.SelectionFont=$fN;$R.SelectionColor=$cU
    $R.AppendText(" https://github.com/Varsett/QuasADBCommander`r`n")
    $R.SelectionColor=$cD
    $R.AppendText(" README_EN.md  |  README_RU.md`r`n")
    $R.AppendText("`r`n (c) 2026 Varset / QUAS toolkit`r`n")
    $L.SelectionStart=0;$L.ScrollToCaret()
    $R.SelectionStart=0;$R.ScrollToCaret()
    $d.ShowDialog()
    (Get-ALV).Focus()}


# ADB status timer
$adbT=New-Object System.Windows.Forms.Timer
$adbT.Interval=3000
$adbT.Add_Tick({
    if($script:AppNamesShowCompleted){if((Get-Date) -lt $script:AppNamesCompletedUntil){Set-Status (T "st_reading_completed" @($script:AppNamesRead,$script:AppNamesTotal)) "Blue";return}else{$script:AppNamesShowCompleted=$false;Set-Status (T "st_connected") "Green";return}}
    if(-not $script:AdbAvailable){Set-Status (T "st_adb_not_found") "Red";return}
    try{
        $psi9=New-Object System.Diagnostics.ProcessStartInfo
        $psi9.FileName=$envAdb;$psi9.Arguments="devices"
        $psi9.UseShellExecute=$false;$psi9.CreateNoWindow=$true
        $psi9.RedirectStandardOutput=$true;$psi9.RedirectStandardError=$true
        $p9=New-Object System.Diagnostics.Process;$p9.StartInfo=$psi9
        [void]$p9.Start()
        $devOut=$p9.StandardOutput.ReadToEnd()
        $p9.WaitForExit()
        $dev=@($devOut -split "`r?`n"|Where-Object{$_ -match "`tdevice$"})
        if($dev.Count -gt 0){
            $serial=($dev[0] -split "`t")[0].Trim()
            if(-not $script:AppNamesBuilding){Set-Status "$(T 'st_connected'): $serial" "Green"}
            if(-not $script:LastAdbConnected){
                $script:LastAdbConnected=$true
                if($script:AppMode){Refresh-AppList}
            }
        }else{
            $script:LastAdbConnected=$false
            Set-Status (T "st_disconnected") "Red"
        }
    }catch{Set-Status "$(T 'st_adb_error'): $_" "Red"}
})
$adbT.Start()

$lvPC.Add_Enter({$lvPC.BackColor=$bgActive;$lvADB.BackColor=$bgInact;$form.Refresh()})
$lvADB.Add_Enter({$lvADB.BackColor=$bgActive;$lvPC.BackColor=$bgInact;$form.Refresh()})
$form.Add_FormClosed({$adbT.Stop();[System.Windows.Forms.Application]::Exit()})

$lvADB.Add_KeyDown({param($s,$e)
    if($e.KeyCode -eq [System.Windows.Forms.Keys]::F9){$e.SuppressKeyPress=$true;Go-Data;return}
    if($e.KeyCode -eq [System.Windows.Forms.Keys]::F10){$e.SuppressKeyPress=$true;Go-Obb;return}
})

$form.Add_KeyDown({param($s,$e)
    if($e.KeyCode -eq "Tab"){$e.SuppressKeyPress=$true
        if($form.ActiveControl -eq $lvPC){$lvADB.Focus()}else{$lvPC.Focus()}
        $form.Refresh()}
    if($e.Control -and $e.KeyCode -eq [System.Windows.Forms.Keys]::A){
        $lv=$form.ActiveControl
        if($lv -is [System.Windows.Forms.ListView]){
            $allP=@($lv.Items|Where-Object{$_.Tag -ne "__GOUP__" -and $_.Tag -ne "__ARCHCLOSE__" -and $null -ne $_.Tag}|ForEach-Object{(Get-ItemTag $_).Path}|Where-Object{$_})
            foreach($it in $lv.Items){
                if($it.Tag -ne "__GOUP__" -and $it.Tag -ne "__ARCHCLOSE__" -and $null -ne $it.Tag){$it.Selected=$true}
            }
            foreach($pp in $allP){[void]$global:SelectedPaths.Add($pp)}
            if($lv.Items.Count -gt 0){$lv.Items[$lv.Items.Count-1].Focused=$true}
            $lv.Invalidate();$e.SuppressKeyPress=$true
        }
    }
    if($e.KeyCode -eq "Space"){
        $lv=$form.ActiveControl
        if($lv -is [System.Windows.Forms.ListView]){
            $item=Get-SelI $lv
            if($null -ne $item -and $item.Tag -ne "__GOUP__" -and $item.Tag -ne "__ARCHCLOSE__"){
                $ti=Get-ItemTag $item
                if($global:SelectedPaths.Contains($ti.Path)){$global:SelectedPaths.Remove($ti.Path)|Out-Null}
                else{[void]$global:SelectedPaths.Add($ti.Path)}
                $lv.Invalidate()}}}
    if($e.KeyCode -eq "Multiply"){
        $lv=$form.ActiveControl
        if($lv -is [System.Windows.Forms.ListView]){
            $allP=@($lv.Items|Where-Object{$_.Tag -ne "__GOUP__" -and $_.Tag -ne "__ARCHCLOSE__" -and $null -ne $_.Tag}|ForEach-Object{(Get-ItemTag $_).Path}|Where-Object{$_})
            $allSel=$true
            foreach($pp in $allP){if(-not $global:SelectedPaths.Contains($pp)){$allSel=$false;break}}
            if($allSel){$global:SelectedPaths.Clear()}
            else{foreach($pp in $allP){[void]$global:SelectedPaths.Add($pp)}}
            $lv.Invalidate()}}
    if($e.Alt -and $e.KeyCode -eq "X"){$form.Close()}
    if($e.KeyCode -eq "Return"){&$navAction}
    if($e.KeyCode -eq "F2"){Rename-Action}
    if($e.Control -and $e.KeyCode -eq "F3"){$e.SuppressKeyPress=$true;Filter-Applications}
    elseif($e.KeyCode -eq "F3"){Search-Action}
    if($e.KeyCode -eq "F4"){Edit-Action}
    if($e.KeyCode -eq "F5"){Copy-Action}
    if($e.KeyCode -eq "F6"){Move-Action}
    if($e.KeyCode -eq "F7"){NewDir-Action}
    if($e.KeyCode -eq "F8" -or $e.KeyCode -eq "Delete"){
        if($script:AppMode -and $form.ActiveControl -eq $lvADB){
            $e.SuppressKeyPress=$true
            App-Uninstall
        }else{
            Delete-Action
        }
    }
    if($e.KeyCode -eq "F9"){$e.SuppressKeyPress=$true;Go-Data}
    if($e.KeyCode -eq "F10"){$e.SuppressKeyPress=$true;Go-Obb}
    if($e.KeyCode -eq "F12"){$e.SuppressKeyPress=$true;Show-LogSettings}
})

$form.Add_Load({Do-Resize;Refresh-Panel "PC";Refresh-Panel "ADB";$lvPC.Focus()})

$form.Add_Shown({
    $form.WindowState="Normal"
    $form.BringToFront();$form.Activate();$lvPC.Focus()
    $script:fgTimer=New-Object System.Windows.Forms.Timer
    $script:fgTimer.Interval=10
    $script:fgTimer.Add_Tick({
        $script:fgTimer.Stop();$script:fgTimer.Dispose();$script:fgTimer=$null
        try{
            [FgWin32]::ForceToForeground($form.Handle)
            $form.TopMost=$true
            $form.Activate()
            $script:fgTimer2=New-Object System.Windows.Forms.Timer
            $script:fgTimer2.Interval=5
            $script:fgTimer2.Add_Tick({
                $script:fgTimer2.Stop();$script:fgTimer2.Dispose();$script:fgTimer2=$null
                $form.TopMost=$false
                [FgWin32]::ForceToForeground($form.Handle)
                $form.Activate()
                $lvPC.Focus()
            })
            $script:fgTimer2.Start()
        }catch{$form.Activate();$lvPC.Focus()}
    })
    $script:fgTimer.Start()
})


[System.Windows.Forms.Application]::Run($form)

# Пауза перед выходом для просмотра логов
#Write-Host "`nScript finished. Press key for exit"
#$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")