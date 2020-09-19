{ lib, fetchFromGitHub, fetchurl, linkFarm, buildGoModule, runCommand, makeWrapper, nixosTests
, assetOverrides ? {}
}:

let
  version = "4.28.2";

  src = fetchFromGitHub {
    owner = "v2ray";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "0q2gpnx7nrnrdkc8fq1ghbki8yyh11hs5bw8rb48jsrnigrg73b8";
  };

  vendorSha256 = "1ghpb5ijpmmq1qysjifj6ss1zk1h2l55r6w7l4a01bp8sxncxarc";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202009160005";
      geoipSha256 = "00hilqqnpfyvxxaiamwmkdpzid763xgig1vk4rxv76npwyixsmj4";
    in fetchurl {
      url = "https://github.com/v2ray/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20200918144814";
      geositeSha256 = "08zdw20wdksp96436j3my145qvyvr9a15lj8j4wdagr64iap5nx7";
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
