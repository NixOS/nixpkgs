{ lib, stdenv, callPackage, fetchurl, fetchFromGitHub, fetchYarnDeps, nixosTests
, brotli, fixup_yarn_lock, jq, nodejs, which, yarn
}:
let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "linux-x64"
    else throw "Unsupported architecture: ${stdenv.hostPlatform.system}";

  bcrypt_version = "5.1.0";
  bcrypt_lib = fetchurl {
    url = "https://github.com/kelektiv/node.bcrypt.js/releases/download/v${bcrypt_version}/bcrypt_lib-v${bcrypt_version}-napi-v3-${arch}-glibc.tar.gz";
    hash = "sha256-I1ceMi7h6flvKBmMIU1qjAU1S6z5MzguHDul3g1zMKw=";
  };

in stdenv.mkDerivation rec {
  pname = "peertube";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "Chocobozzz";
    repo = "PeerTube";
    rev = "v${version}";
    hash = "sha256-Z2l0I/vVEx4ivC87N26QaUnQjySU/XRFW3biEwl7Od0=";
  };

  yarnOfflineCacheServer = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-EVviTrgSZYsi68hJIlSC9ArQS3aVp6EQNKbkVx12WJk=";
  };

  yarnOfflineCacheTools = fetchYarnDeps {
    yarnLock = "${src}/server/tools/yarn.lock";
    hash = "sha256-maPR8OCiuNlle0JQIkZSgAqW+BrSxPwVm6CkxIrIg5k=";
  };

  yarnOfflineCacheClient = fetchYarnDeps {
    yarnLock = "${src}/client/yarn.lock";
    hash = "sha256-ehA1W1bDXzApTpkWH7MEAQ9Ek73q3En76/LdvJhxh2Q=";
  };

  nativeBuildInputs = [ brotli fixup_yarn_lock jq nodejs which yarn ];

  buildPhase = ''
    # Build node modules
    export HOME=$PWD
    fixup_yarn_lock ~/yarn.lock
    fixup_yarn_lock ~/server/tools/yarn.lock
    fixup_yarn_lock ~/client/yarn.lock
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheServer
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/server/tools
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheTools
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/client
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheClient
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress

    patchShebangs ~/node_modules
    patchShebangs ~/server/tools/node_modules
    patchShebangs ~/client/node_modules
    patchShebangs ~/scripts

    # Fix bcrypt node module
    cd ~/node_modules/bcrypt
    if [ "${bcrypt_version}" != "$(cat package.json | jq -r .version)" ]; then
      echo "Mismatching version please update bcrypt in derivation"
      exit
    fi
    mkdir -p ./lib/binding && tar -C ./lib/binding -xf ${bcrypt_lib}

    # Return to home directory
    cd ~

    # Build PeerTube server
    npm run tsc -- --build ./tsconfig.json
    npm run resolve-tspaths:server
    cp -r "./server/static" "./server/assets" "./dist/server"
    cp -r "./server/lib/emails" "./dist/server/lib"

    # Build PeerTube tools
    cp -r "./server/tools/node_modules" "./dist/server/tools"
    npm run tsc -- --build ./server/tools/tsconfig.json
    npm run resolve-tspaths:server

    # Build PeerTube client
    npm run build:client
  '';

  installPhase = ''
    mkdir -p $out/dist
    mv ~/dist $out
    mv ~/node_modules $out/node_modules
    mv ~/server/tools/node_modules $out/dist/server/tools/node_modules
    mkdir $out/client
    mv ~/client/{dist,node_modules,package.json,yarn.lock} $out/client
    mv ~/{config,scripts,support,CREDITS.md,FAQ.md,LICENSE,README.md,package.json,tsconfig.json,yarn.lock} $out

    # Create static gzip and brotli files
    find $out/client/dist -type f -regextype posix-extended -iregex '.*\.(css|eot|html|js|json|svg|webmanifest|xlf)' | while read file; do
      gzip -9 -n -c $file > $file.gz
      brotli --best -f $file -o $file.br
    done
  '';

  passthru.tests.peertube = nixosTests.peertube;

  meta = with lib; {
    description = "A free software to take back control of your videos";
    longDescription = ''
      PeerTube aspires to be a decentralized and free/libre alternative to video
      broadcasting services.
      PeerTube is not meant to become a huge platform that would centralize
      videos from all around the world. Rather, it is a network of
      inter-connected small videos hosters.
      Anyone with a modicum of technical skills can host a PeerTube server, aka
      an instance. Each instance hosts its users and their videos. In this way,
      every instance is created, moderated and maintained independently by
      various administrators.
      You can still watch from your account videos hosted by other instances
      though if the administrator of your instance had previously connected it
      with other instances.
    '';
    license = licenses.agpl3Plus;
    homepage = "https://joinpeertube.org/";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ immae izorkin matthiasbeyer mohe2015 stevenroose ];
  };
}
