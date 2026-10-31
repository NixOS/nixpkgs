{
  lib,
  fetchzip,
  makeDesktopItem,
  writeText,
}:

let
  description = "Application to flash your MediaTek (MTK) SmartPhone";
in
{
  mkSrc =
    { version, hash }:
    fetchzip {
      url = "https://spflashtools.com/wp-content/uploads/SP_Flash_Tool_v${version}_Linux.zip";
      inherit hash;
    };

  mkDesktopItem =
    major:
    makeDesktopItem {
      name = "SP FlashTool ${major}";
      exec = "spflashtool${major}";
      icon = "spflashtool${major}";
      comment = description;
      desktopName = "SP FlashTool ${major}";
      genericName = "Mediatek FlashTool V${major}";
      categories = [
        "Development"
        "Engineering"
        "Utility"
      ];
      startupWMClass = "FlashTool";
    };

  # Upstream option.ini with saner defaults: no welcome page, no update
  # check, readback entries grouped by scatter sections
  mkOptionIni =
    name: overrides:
    writeText name (
      lib.generators.toINI { } (
        lib.recursiveUpdate {
          Trace = {
            EnableTrace = true;
            CleanOlder = 2;
          };
          Conn = {
            Battery = 0;
            PrintDriverVersion = false;
          };
          Language.CurrentLang = 0;
          Download = {
            DAChksum = 0;
            RiskReminder = false;
            CheckRPMB = false;
            StorageLifeCycleCheck = true;
          };
          DownloadScene = {
            Format_All_Download = true;
            Firmware_Upgrade = true;
            Download_Only = true;
          };
          WelcomePage.ShowWelcome = false;
          CheckUpdate.Update = false;
          ReadBack.ShowByScatter = true;
          ModemManager.RunModemManagerCmd = false;
        } overrides
      )
    );

  mkMeta =
    { major, minor }:
    {
      inherit description;
      longDescription = ''
        SP Flash Tool for Linux enables users to flash Stock Firmware (ROMs),
        unbrick bricked devices, upgrade or downgrade their operating system,
        and perform advanced tasks like memory testing and parameter editing.
      '';
      homepage = "https://spflashtools.com/linux/sp-flash-tool-v${major}-${minor}-for-linux";
      license = lib.licenses.unfree;
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      maintainers = with lib.maintainers; [ dmfrpro ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "spflashtool${major}";
    };
}
