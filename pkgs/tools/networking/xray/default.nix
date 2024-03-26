{ lib
, fetchFromGitHub
, symlinkJoin
, buildGoModule
, makeWrapper
, nix-update-script
, v2ray-geoip
, v2ray-domain-list-community
, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:

buildGoModule rec {
  pname = "xray";
  version = "1.8.7";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${version}";
    hash = "sha256-yS2DsM9RVAHStoqWVns9GkoYuFS69v7S3uTbRaV9Aog=";
  };

  vendorHash = "sha256-HRUUZjc0TcZ/fXTneG/h/m3QyesHL+/Nu1pFqZ3LUDI=";

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
