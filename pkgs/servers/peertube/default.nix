{ lib, stdenv, callPackage, fetchurl, fetchFromGitHub, buildGoModule, fetchYarnDeps, nixosTests
, esbuild, fixup_yarn_lock, jq, nodejs, yarn
, nodePackages, youtube-dl
}:
let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "linux-x64"
    else throw "Unsupported architecture: ${stdenv.hostPlatform.system}";

  version = "3.4.1";

  source = fetchFromGitHub {
    owner = "Chocobozzz";
    repo = "PeerTube";
    rev = "v${version}";
    sha256 = "0l1ibqmliy4aq60a16v383v4ijv1c9sf2a35k9q365mkl42jbzx1";
  };

  yarnOfflineCacheServer = fetchYarnDeps {
    yarnLock = "${source}/yarn.lock";
    sha256 = "0zyxf1km79w6329jay4bcpw5bgvhnvmvl11r9hka5c6s46d3ms7n";
  };

  yarnOfflineCacheTools = fetchYarnDeps {
    yarnLock = "${source}/server/tools/yarn.lock";
    sha256 = "12xmwc8lnalcpx3nww457avn5zw04ly4pp4kjxkvhsqs69arfl2m";
  };

  yarnOfflineCacheClient = fetchYarnDeps {
    yarnLock = "${source}/client/yarn.lock";
    sha256 = "1glnip6mpizif36vil61sw8i8lnn0jg5hrqgqw6k4cc7hkd2qkpc";
  };

  bcrypt_version = "5.0.1";
  bcrypt_lib = fetchurl {
    url = "https://github.com/kelektiv/node.bcrypt.js/releases/download/v${bcrypt_version}/bcrypt_lib-v${bcrypt_version}-napi-v3-${arch}-glibc.tar.gz";
    sha256 = "3R3dBZyPansTuM77Nmm3f7BbTDkDdiT2HQIrti2Ottc=";
  };

  wrtc_version = "0.4.7";
  wrtc_lib = fetchurl {
    url = "https://node-webrtc.s3.amazonaws.com/wrtc/v${wrtc_version}/Release/${arch}.tar.gz";
    sha256 = "1zd3jlwq3lc2vhmr3bs1h6mrzyswdp3y20vb4d9s67ir9q7jn1zf";
  };

  esbuild_locked = buildGoModule rec {
    pname = "esbuild";
    version = "0.12.17";

    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${version}";
      sha256 = "16xxscha2y69mgm20rpjdxykyqiy0qy8gayh8046q6m0sf6834y1";
    };
    vendorSha256 = "1n5538yik72x94vzfq31qaqrkpxds5xys1wlibw2gn2am0z5c06q";
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "peertube";
  src = source;

  nativeBuildInputs = [ esbuild fixup_yarn_lock jq nodejs yarn ];

  buildInputs = [ nodePackages.node-gyp-build youtube-dl ];

  buildPhase = ''
    # Build node modules
    export HOME=$PWD
    fixup_yarn_lock ~/yarn.lock
    fixup_yarn_lock ~/server/tools/yarn.lock
    fixup_yarn_lock ~/client/yarn.lock
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCacheServer}
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/server/tools
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCacheTools}
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/client
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCacheClient}
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

    # Fix youtube-dl node module
    cd ~/node_modules/youtube-dl
    mkdir ./bin
    ln -s ${youtube-dl}/bin/youtube-dl ./bin/youtube-dl
    cat > ./bin/details <<EOF
    {"version":"${youtube-dl.version}","path":null,"exec":"youtube-dl"}
    EOF

    # Fix wrtc node module
    cd ~/server/tools/node_modules/wrtc
    if [ "${wrtc_version}" != "$(cat package.json | jq -r .version)" ]; then
      echo "Mismatching version please update wrtc in derivation"
      exit
    fi
    mkdir -p ./build && tar -C ./build -xf ${wrtc_lib}

    # Build PeerTube server
    cd ~
    npm run build:server

    # Build PeerTube tools
    npm run tsc -- --build ./server/tools/tsconfig.json

    # Build PeerTube client
    export ESBUILD_BINARY_PATH="${esbuild_locked}/bin/esbuild"
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
