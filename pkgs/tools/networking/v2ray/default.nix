{ lib, fetchFromGitHub, fetchurl, linkFarm, buildGoModule, runCommand, makeWrapper, nixosTests
, assetOverrides ? {}
}:

let
  version = "4.27.5";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "168kz8hq7mcfy6h758mmrky550p04bi9jsfqhy67jcxq81874m2k";
  };

  vendorSha256 = "0m889byxw70vv1mzlivalq444byp0y182nqqzdr458gfifvpc7s7";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202009020005";
      geoipSha256 = "1xsy678cpqv6ycnhzl3pms76ic40aggq46q9dsd5ghj94mcx9837";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20200901194123";
      geositeSha256 = "0fjx1wrq14d9v326k4fjwca3h5nv8ghk11kprf6jkjncjszwvgby";
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

  buildInputs = [ assetsDrv core ];
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