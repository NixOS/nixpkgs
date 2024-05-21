{ lib
, stdenv
, callPackage
, fetchurl
, fetchFromGitHub
, fetchYarnDeps
, nixosTests
, brotli
, fixup-yarn-lock
, jq
, nodejs
, which
, yarn
}:
let
  bcryptHostPlatformAttrs = {
    x86_64-linux = {
      arch = "linux-x64";
      libc = "glibc";
      hash = "sha256-C5N6VgFtXPLLjZt0ZdRTX095njRIT+12ONuUaBBj7fQ=";
    };
    aarch64-linux = {
      arch = "linux-arm64";
      libc = "glibc";
      hash = "sha256-TerDujO+IkSRnHYlSbAKSP9IS7AT7XnQJsZ8D8pCoGc=";
    };
    x86_64-darwin = {
      arch = "darwin-x64";
      libc = "unknown";
      hash = "sha256-gphOONWujbeCCr6dkmMRJP94Dhp1Jvp2yt+g7n1HTv0=";
    };
    aarch64-darwin = {
      arch = "darwin-arm64";
      libc = "unknown";
      hash = "sha256-JMnELVUxoU1C57Tzue3Sg6OfDFAjfCnzgDit0BWzmlo=";
    };
  };
  bcryptAttrs = bcryptHostPlatformAttrs."${stdenv.hostPlatform.system}" or
    (throw "Unsupported architecture: ${stdenv.hostPlatform.system}");
  bcryptVersion = "5.1.1";
  bcryptLib = fetchurl {
    url = "https://github.com/kelektiv/node.bcrypt.js/releases/download/v${bcryptVersion}/bcrypt_lib-v${bcryptVersion}-napi-v3-${bcryptAttrs.arch}-${bcryptAttrs.libc}.tar.gz";
    inherit (bcryptAttrs) hash;
  };
in
stdenv.mkDerivation rec {
  pname = "peertube";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "Chocobozzz";
    repo = "PeerTube";
    rev = "v${version}";
    hash = "sha256-FxXIvibwdRcv8OaTQEXiM6CvWOIptfQXDQ1/PW910wg=";
  };

  yarnOfflineCacheServer = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-RJX92EgEIXWB1wNFRl8FvseOqBT+7m6gs+pMyoodruk=";
  };

  yarnOfflineCacheClient = fetchYarnDeps {
    yarnLock = "${src}/client/yarn.lock";
    hash = "sha256-vr9xn5NXwiUS59Kgl8olCtkMgxnI1TKQzibKbb8RNXA=";
  };

  yarnOfflineCacheAppsCli = fetchYarnDeps {
    yarnLock = "${src}/apps/peertube-cli/yarn.lock";
    hash = "sha256-xsB71bnaPn/9/f1KHyU3TTwx+Q+1dLjWmNK2aVJgoRY=";
  };

  yarnOfflineCacheAppsRunner = fetchYarnDeps {
    yarnLock = "${src}/apps/peertube-runner/yarn.lock";
    hash = "sha256-9w3aLuiLs7SU00YwuE0ixfiD77gCakXT4YeRpfsgGz0=";
  };

  outputs = [ "out" "cli" "runner" ];

  nativeBuildInputs = [ brotli fixup-yarn-lock jq which yarn ];

  buildInputs = [ nodejs ];

  buildPhase = ''
    # Build node modules
    export HOME=$PWD
    fixup-yarn-lock ~/yarn.lock
    fixup-yarn-lock ~/client/yarn.lock
    fixup-yarn-lock ~/apps/peertube-cli/yarn.lock
    fixup-yarn-lock ~/apps/peertube-runner/yarn.lock
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheServer
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/client
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheClient
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/apps/peertube-cli
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheAppsCli
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/apps/peertube-runner
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheAppsRunner
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress

    patchShebangs ~/{node_modules,client/node_modules,/apps/peertube-cli/node_modules,apps/peertube-runner/node_modules,scripts}

    # Fix bcrypt node module
    cd ~/node_modules/bcrypt
    if [ "${bcryptVersion}" != "$(cat package.json | jq -r .version)" ]; then
      echo "Mismatching version please update bcrypt in derivation"
      exit
    fi
    mkdir -p ./lib/binding && tar -C ./lib/binding -xf ${bcryptLib}

    # Return to home directory
    cd ~

    # Build PeerTube server
    npm run build:server

    # Build PeerTube client
    npm run build:client

    # Build PeerTube cli
    npm run build:peertube-cli
    patchShebangs ~/apps/peertube-cli/dist/peertube.js

    # Build PeerTube runner
    npm run build:peertube-runner
    patchShebangs ~/apps/peertube-runner/dist/peertube-runner.js

    # Clean up declaration files
    find ~/dist/ \
      ~/packages/core-utils/dist/ \
      ~/packages/ffmpeg/dist/ \
      ~/packages/models/dist/ \
      ~/packages/node-utils/dist/ \
      ~/packages/server-commands/dist/ \
      ~/packages/typescript-utils/dist/ \
      \( -name '*.d.ts' -o -name '*.d.ts.map' \) -type f -delete
  '';

  installPhase = ''
    mkdir -p $out/dist
    mv ~/dist $out
    mv ~/node_modules $out/node_modules
    mkdir $out/client
    mv ~/client/{dist,node_modules,package.json,yarn.lock} $out/client
    mkdir -p $out/packages/{core-utils,ffmpeg,models,node-utils,server-commands,typescript-utils}
    mv ~/packages/core-utils/{dist,package.json} $out/packages/core-utils
    mv ~/packages/ffmpeg/{dist,package.json} $out/packages/ffmpeg
    mv ~/packages/models/{dist,package.json} $out/packages/models
    mv ~/packages/node-utils/{dist,package.json} $out/packages/node-utils
    mv ~/packages/server-commands/{dist,package.json} $out/packages/server-commands
    mv ~/packages/typescript-utils/{dist,package.json} $out/packages/typescript-utils
    mv ~/{config,support,CREDITS.md,FAQ.md,LICENSE,README.md,package.json,yarn.lock} $out

    mkdir -p $cli/bin
    mv ~/apps/peertube-cli/{dist,node_modules,package.json,yarn.lock} $cli
    ln -s $cli/dist/peertube.js $cli/bin/peertube-cli

    mkdir -p $runner/bin
    mv ~/apps/peertube-runner/{dist,node_modules,package.json,yarn.lock} $runner
    ln -s $runner/dist/peertube-runner.js $runner/bin/peertube-runner

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
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = with maintainers; [ immae izorkin mohe2015 stevenroose ];
  };
}
