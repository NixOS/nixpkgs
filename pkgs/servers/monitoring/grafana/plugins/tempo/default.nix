{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "tempo";
  version = "13.2.2";
  zipHash = "sha256-Wa6ngZuxVAglTK6vvyYR/IxOz85Vno9fapJyiUoCYMI=";
  meta = {
    description = "Support for tempo data-source";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.unix;
  };
}
