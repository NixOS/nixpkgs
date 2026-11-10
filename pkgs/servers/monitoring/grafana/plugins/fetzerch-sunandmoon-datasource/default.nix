{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "fetzerch-sunandmoon-datasource";
  inherit (lib.importTOML ./sources.toml) version packages;
  meta = {
    description = "Calculates the position of Sun and Moon as well as the Moon illumination using SunCalc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nagisa ];
  };
}
