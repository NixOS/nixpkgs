{ lib, fetchFromGitHub, fetchurl, linkFarm, buildGoModule, runCommand, makeWrapper, nixosTests
, assetOverrides ? {}
}:

let
  version = "4.38.3";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "1vsq98h6zbm3wz1mgphl7dqlabgfg53fhkyn47vfbhhkbx6nwl7c";
  };

  vendorSha256 = "sha256-jXpGlJ30xBttysbUekMdw8fH0KVfPufWq0t7AXZrDEQ=";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202104300531";
      geoipSha256 = "0srskpp0pmw4fzp4lgachjjvig4fy96523r7aj2bwig0ipfgr401";
    in fetchurl {
      url = "https://github.com/v2fly/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20210430100800";
      geositeSha256 = "0wp111iip3lhkgpbrzzivl5flj44vj7slx9w7k307sls6hmjzlcb";
    in fetchurl {
      url = "https://github.com/v2fly/domain-list-community/releases/download/${geositeRev}/dlc.dat";
      sha256 = geositeSha256;
    };

  } // assetOverrides;

  assetsDrv = linkFarm "v2ray-assets" (lib.mapAttrsToList (name: path: {
    inherit name path;
  }) assets);

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
      --set-default V2RAY_LOCATION_ASSET ${assetsDrv}
  done
''
