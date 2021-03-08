{ lib, fetchFromGitHub, fetchurl, linkFarm, buildGoModule, runCommand, makeWrapper, nixosTests
, assetOverrides ? {}
}:

let
  version = "4.35.1";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "07fih1hnnv1a4aj6sb63408vqf10bgk74lhqqv63lvm7gaz73srd";
  };

  vendorSha256 = "sha256-+kI9p0lu4PbLe6jhWqTfRYXHFOOrKmY36LzdcQT9BWw=";

  assets = {
    # MIT licensed
    "geoip.dat" = let
      geoipRev = "202103080146";
      geoipSha256 = "1qwmz5fxqqxcjw5jm9dvgpmbin2q69j9wdx4xv3pm8fc47wzx8w5";
    in fetchurl {
      url = "https://github.com/v2fly/geoip/releases/download/${geoipRev}/geoip.dat";
      sha256 = geoipSha256;
    };

    # MIT licensed
    "geosite.dat" = let
      geositeRev = "20210308021214";
      geositeSha256 = "1fp787wlzdjn2gxx4zmqrqqzqcq4xd10pqx8q919fag0kkzdm23s";
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
