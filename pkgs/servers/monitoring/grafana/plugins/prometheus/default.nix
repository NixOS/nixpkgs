{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "prometheus";
  version = "13.2.2";
  zipHash = "sha256-AzAVjFIwtAC85ZXrcXtwE03y2zfz8ilE/J1H49swrNo=";
  meta = {
    description = "Support for prometheus data-source";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.unix;
  };
}
