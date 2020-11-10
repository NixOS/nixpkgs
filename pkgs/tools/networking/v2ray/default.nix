{ lib, fetchFromGitHub, fetchurl, linkFarm, buildGoModule, runCommand, makeWrapper, nixosTests
, assetOverrides ? {}
}:

let
  version = "4.31.0";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "0s0blc05nrqm78qslv5xb42pjlx5v8qqwg0pwbzhxn9s71x2669m";
  };

  vendorSha256 = "0n2mf19fvgk5x0j2wwm4zk9xikzvl6cdvw26qar91wzcsraf5z2d";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202009300006";
      geoipSha256 = "1ss2izqlmrp5b5kpw804jk6c1nyimwlccbkikix3bwfaz4vlv1nc";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20201010021828";
      geositeSha256 = "0gpfhcf4iyx7ip7rlkb0l1q64w84zvmcah52qyjwljs6l4p3hrj9";
    in fetchurl {
      url = "https://github.com/v2ray/domain-list-community/releases/download/${geositeRev}/dlc.dat";
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
      runHook preBuild

      go build -o v2ray v2ray.com/core/main
      go build -o v2ctl v2ray.com/core/infra/control/main

      runHook postBuild
    '';

    installPhase = ''
      install -Dm755 v2ray v2ctl -t $out/bin
    '';
  };

in runCommand "v2ray-${version}" {
  inherit version;

  nativeBuildInputs = [ makeWrapper ];

  meta = {
    homepage = "https://www.v2ray.com/en/index.html";
    description = "A platform for building proxies to bypass network restrictions";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ servalcatty ];
  };

  passthru = {
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
