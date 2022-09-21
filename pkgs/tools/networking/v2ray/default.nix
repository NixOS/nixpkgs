{ lib
, callPackage
, symlinkJoin
, runCommand
, makeWrapper
, nixosTests
, v2ray-geoip
, v2ray-domain-list-community
, assets ? [ v2ray-geoip v2ray-domain-list-community ]
}:

let
  core = callPackage ./core.nix { };
  asset = symlinkJoin {
    name = "v2ray-assets";
    paths = assets;
  };
in
runCommand "v2ray-${core.version}"
{
  inherit (core) src version meta;
  nativeBuildInputs = [ makeWrapper ];
  passthru = {
    inherit core;
    updateScript = ./update.sh;
    tests.simple = nixosTests.v2ray;
  };
} ''
  makeWrapper "${core}/bin/v2ray" "$out/bin/v2ray" \
    --suffix XDG_DATA_DIRS ${asset}/share
''
