{ lib
, fetchFromGitHub
<<<<<<< HEAD
, symlinkJoin
, buildGoModule
=======
, fetchurl
, symlinkJoin
, buildGoModule
, runCommand
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, makeWrapper
, nix-update-script
, v2ray-geoip
, v2ray-domain-list-community
, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:

<<<<<<< HEAD
buildGoModule rec {
  pname = "xray";
  version = "1.8.4";
=======
let
  assetsDrv = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };

in
buildGoModule rec {
  pname = "xray";
  version = "1.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Hu0BP4BzoELRjJ8WdF3JS/ffxd3bpH+kauWqaMh/o1I=";
  };

  vendorHash = "sha256-ihTOKtppOTYdulzwIwD8oWaS2OPs+QCdqPTvqucw7xY=";
=======
    sha256 = "sha256-yvfBrMQPvIzuLT9wAvQ9QdAIfjzFt7B+L4N8q9SwufA=";
  };

  vendorSha256 = "sha256-mr07woy6QXRz8iM4Yzl1Wv5+jlG7ws/fDAnuHjNiUPc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
      --suffix V2RAY_LOCATION_ASSET : $assetsDrv/share/v2ray \
      --suffix XRAY_LOCATION_ASSET : $assetsDrv/share/v2ray
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A platform for building proxies to bypass network restrictions. A replacement for v2ray-core, with XTLS support and fully compatible configuration";
    homepage = "https://github.com/XTLS/Xray-core";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ iopq ];
  };
}
