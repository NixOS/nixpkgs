{ mkYarnPackage
, lib
, fetchFromGitHub
, nixosTests
, python3
, nodejs
  # needed for the NixOS test
, dataDir ? "/opt/zigbee2mqtt/data"
}:
let
  inherit (lib.importJSON ./package.json) name version;
in
mkYarnPackage {
  src = fetchFromGitHub {
    owner = "Koenkk";
    repo = name;
    rev = version;
    sha256 = "sha256-HoheB+/K4THFqgcC79QZM71rDPv2JB+S6y4K1+sdASo=";
  };

  postPatch = ''
    # Prevent application from self updating
    sed -i index.js \
      -e '/await checkDist/d'
    # Fix path to node modules; yarn and npm seems to have different packaging
    sed -i lib/util/utils.ts \
      -e "s/\('node_modules'\)/'..', '..', \1/"
  '';

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  yarnFlags = [
    "--offline"
    "--frozen-lockfile"
    "--no-progress"
    "--non-interactive"
  ];

  yarnPreBuild = ''
    export npm_config_nodedir=${nodejs}
  '';

  pkgConfig.unix-dgram.buildInputs = [ python3 ];
  pkgConfig."@serialport/bindings".buildInputs = [ python3 ];

  buildPhase = ''
    yarn --offline build
  '';

  distPhase = ":";

  passthru.tests.zigbee2mqtt = nixosTests.zigbee2mqtt;

  meta = with lib; {
    description = "Zigbee to MQTT bridge using zigbee-shepherd";
    license = licenses.gpl3;
    homepage = "https://github.com/Koenkk/zigbee2mqtt";
    maintainers = with maintainers; [ sweber ck3d ];
    platforms = platforms.linux;
  };
}
