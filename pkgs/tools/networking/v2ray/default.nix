{ lib, fetchFromGitHub, fetchurl, linkFarm, buildGoModule, runCommand, makeWrapper, nixosTests
, assetOverrides ? {}
}:

let
  version = "4.34.0";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "0x6smffpvnrk76plnsk31qqznkyz06dh4sazncp2l3y9va8k2jb1";
  };

  vendorSha256 = "077jnjsmhzr0idrk7pifr5s2r9yjf1v9bvj177n2k2ln8w3wgx3g";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202101070033";
      geoipSha256 = "11naj51pzchdrjmkp1dqzcby1i2fhbq0mncwm4d5q5mh3chyizsf";
    in fetchurl {
      url = "https://github.com/v2fly/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20210106164413";
      geositeSha256 = "0chc7jb3yzgrrjkpd3s1rlim5qgf6j2kp952fvkhpwmnap86aip7";
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
  inherit version;
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
