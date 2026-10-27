{
  buildSddmThemePackage,
  plasma-desktop,
  plasma-workspace,
}:
buildSddmThemePackage {
  pname = "sddm-theme-breeze";
  inherit (plasma-desktop) version;

  src = "${plasma-desktop}/share/sddm/themes/breeze";

  sddmBuildInputs = [ plasma-workspace ];
  configPath = "theme.conf";

  meta = {
    description = "Breeze theme for SDDM";
    inherit (plasma-desktop.meta) homepage license teams;
  };
}
