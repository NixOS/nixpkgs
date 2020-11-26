{ lib, fetchFromGitHub, fetchurl, linkFarm, buildGoModule, runCommand, makeWrapper, nixosTests
, assetOverrides ? {}
}:

let
  version = "4.32.1";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "1mlrl5fz1v3bcb83pczqp859d8w9mi7jj600a2yw7xm372w2irk8";
  };

  vendorSha256 = "1mz1acdj8ailgyqrr1v47n36qc24ggzw5rmj4p2awfwz3gp2yz6z";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202011050012";
      geoipSha256 = "1d2n3hskgdmcfk1nl7a8lxxz325p84i7gz44cs77z1m9r7c2vsjy";
    in fetchurl {
      url = "https://github.com/v2fly/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20201102141726";
      geositeSha256 = "0sn2f5vd6w94ryh845mnbfyjzycg7cvb66rkzh37pg9l7fvgs4jh";
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
      runHook preBuild

      go build -o v2ray v2ray.com/core/main
      go build -o v2ctl v2ray.com/core/infra/control/main

      runHook postBuild
    '';

    installPhase = ''
      install -Dm755 v2ray v2ctl -t $out/bin
    '';

    meta = {
      homepage = "https://www.v2ray.com/en/index.html";
      description = "A platform for building proxies to bypass network restrictions";
      # The license of the dependency `https://github.com/XTLS/Go` doesn't allowed user to modify its source code,
      # which made it unfree.
      license = with lib.licenses; [ mit unfree ];
      maintainers = with lib.maintainers; [ servalcatty ];
    };
  };

in runCommand "v2ray-${version}" {
  inherit version;
  inherit (core) meta;

  nativeBuildInputs = [ makeWrapper ];

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
