{ lib
, fetchFromGitHub
, fetchurl
, symlinkJoin
, buildGoModule
, runCommand
, makeWrapper
, nix-update-script
, v2ray-geoip
, v2ray-domain-list-community
, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:

let
  assetsDrv = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };

in
buildGoModule rec {
  pname = "xray";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${version}";
    sha256 = "0g2bmy522lhip0rgb3hqyi3bidf4ljyjvvv3n1kb6lvm0p3br51b";
  };

  vendorSha256 = "sha256-QAF/05/5toP31a/l7mTIetFhXuAKsT69OI1K/gMXei0=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  ldflags = [ "-s" "-w" "-buildid=" ];
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
      --suffix XRAY_LOCATION_ASSET : $assetsDrv/share/v2ray
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = {
    description = "A platform for building proxies to bypass network restrictions. A replacement for v2ray-core, with XTLS support and fully compatible configuration";
    homepage = "https://github.com/XTLS/Xray-core";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ iopq ];
  };
}
