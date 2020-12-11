{ lib, fetchFromGitHub, fetchurl, linkFarm, buildGoModule, runCommand, makeWrapper, nixosTests
, assetOverrides ? {}
}:

let
  version = "4.33.0";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "05w714i56nipp7m985g6zqq6ljz0w5ihxrgs93j10llfdd089iig";
  };

  vendorSha256 = "0ix5kxldgbcb10jh0l64lrh8qzla4qvsxi6vanb73y7lbsix120w";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202012030015";
      geoipSha256 = "1qy9h0721y5kjcp0s859lhj253jfi3d3i658gpc4kmij2l5dxm5w";
    in fetchurl {
      url = "https://github.com/v2fly/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20201207123222";
      geositeSha256 = "03xckk39rrda42cam2awbsh0gib6rhmz28asc8vx29lsp9g2bj6n";
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
