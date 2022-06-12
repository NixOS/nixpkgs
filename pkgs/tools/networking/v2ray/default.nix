{ lib, fetchFromGitHub, fetchurl, symlinkJoin, buildGoModule, runCommand, makeWrapper, nixosTests
, v2ray-geoip, v2ray-domain-list-community, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:

let
  version = "4.45.0";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "sha256-vVCWCppGeAc7dwY0fX+G0CU3Vy6OBPpDBUOBK3ykg60=";
  };

  vendorSha256 = "sha256-TbWMbIT578I8xbNsKgBeSP4MewuEKpfh62ZbJIeHgDs=";

  assetsDrv = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };

  core = buildGoModule rec {
    pname = "v2ray-core";
    inherit version src;

    inherit vendorSha256;

    doCheck = false;

    buildPhase = ''
      buildFlagsArray=(-v -p $NIX_BUILD_CORES -ldflags="-s -w")
      runHook preBuild
      go build "''${buildFlagsArray[@]}" -o v2ray ./main
      go build "''${buildFlagsArray[@]}" -o v2ctl -tags confonly ./infra/control/main
      runHook postBuild
    '';

    installPhase = ''
      install -Dm755 v2ray v2ctl -t $out/bin
    '';

    meta = {
      homepage = "https://www.v2fly.org/en_US/";
      description = "A platform for building proxies to bypass network restrictions";
      license = with lib.licenses; [ mit ];
      maintainers = with lib.maintainers; [ servalcatty ];
    };
  };

in runCommand "v2ray-${version}" {
  inherit src version;
  inherit (core) meta;

  nativeBuildInputs = [ makeWrapper ];

  passthru = {
    inherit core;
    updateScript = ./update.sh;
    tests = {
      simple-vmess-proxy-test = nixosTests.v2ray;
    };
  };

} ''
  for file in ${core}/bin/*; do
    makeWrapper "$file" "$out/bin/$(basename "$file")" \
      --set-default V2RAY_LOCATION_ASSET ${assetsDrv}/share/v2ray
  done
''
