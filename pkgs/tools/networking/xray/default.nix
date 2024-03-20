{ lib
, fetchFromGitHub
, symlinkJoin
, buildGo122Module
, makeWrapper
, nix-update-script
, v2ray-geoip
, v2ray-domain-list-community
, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:

buildGo122Module rec {
  pname = "xray";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${version}";
    hash = "sha256-5ojpbIKus3xJ1TNd7qmV7IBUWKfhhIEIWwNDn0QU6Bo";
  };

  vendorHash = "sha256-TK2bnDhc6ASiPisLZBQBfuoVKgzhYqiYtvPw4LeP1Bw=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  ldflags = [ "-s" "-w" ];
  subPackages = [ "main" ];

   installPhase = ''
    runHook preInstall
    install -Dm555 "$GOPATH"/bin/main $out/bin/xray
    runHook postInstall
  '';

  assetsDrv = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };

  postFixup = ''
    wrapProgram $out/bin/xray \
      --suffix V2RAY_LOCATION_ASSET : $assetsDrv/share/v2ray \
      --suffix XRAY_LOCATION_ASSET : $assetsDrv/share/v2ray
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A platform for building proxies to bypass network restrictions. A replacement for v2ray-core, with XTLS support and fully compatible configuration";
    mainProgram = "xray";
    homepage = "https://github.com/XTLS/Xray-core";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ iopq ];
  };
}
