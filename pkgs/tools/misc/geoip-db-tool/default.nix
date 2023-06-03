{ lib, rustPlatform, fetchFromGitHub, tor }:

rustPlatform.buildRustPackage {
  version = "0.1.0";
  pname = "geoip-db-tool";

  src = fetchFromGitHub {
    owner = "torproject";
    repo = "tor";
    rev = "tor-${tor.version}";
    sha256 = "sha256-tOLHwSwo/YK6DeBjQCdOX/C1U9LzVkKSidQ5vgi80fI=";
  };

  sourceRoot = "source/scripts/maint/geoip/geoip-db-tool";

  cargoHash = "sha256-JstybmGBLsnMCAIUAuW22Dlk5s+53Nv5PZ/6K4yNYrc=";

  meta = with lib; {
    homepage = "https://github.com/torproject/tor/tree/main/scripts/maint/geoip";
    description = "A tool used to generate geoip CSV file from IPFire dumped database";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ linsui ];
    platforms = platforms.unix;
  };
}
