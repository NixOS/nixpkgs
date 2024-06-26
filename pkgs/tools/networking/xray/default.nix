{
  lib,
  fetchFromGitHub,
  symlinkJoin,
  buildGoModule,
  makeWrapper,
  nix-update-script,
  v2ray-geoip,
  v2ray-domain-list-community,
  assets ? [
    v2ray-geoip
    v2ray-domain-list-community
  ],
}:

buildGoModule rec {
  pname = "xray";
  version = "1.8.16";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${version}";
    hash = "sha256-IHa+7eZkDDK8ZH+WUMoD0F9eiDvD9yYtFrTswBA00O0=";
  };

  vendorHash = "sha256-nMVMbZPIn/mBHgPqH026t1dgi6t/RT+jhT/KseRO1fE=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];
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
      --set-default V2RAY_LOCATION_ASSET $assetsDrv/share/v2ray \
      --set-default XRAY_LOCATION_ASSET $assetsDrv/share/v2ray
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Platform for building proxies to bypass network restrictions. A replacement for v2ray-core, with XTLS support and fully compatible configuration";
    mainProgram = "xray";
    homepage = "https://github.com/XTLS/Xray-core";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ iopq ];
  };
}
