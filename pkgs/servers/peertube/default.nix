{ light ? null, pkgs, stdenv, lib, fetchurl, fetchFromGitHub, callPackage
, nodejs ? pkgs.nodejs-12_x
, jq, youtube-dl, nodePackages, yarn2nix-moretea }:

let
  version = "3.0.1";

  source = fetchFromGitHub {
    owner = "Chocobozzz";
    repo = "PeerTube";
    rev = "v${version}";
    sha256 = "bIXt5bQiBBlNDFXYzcdQA8qp4nse5epUx/XQOguDOX8=";
  };

  patchedSource = stdenv.mkDerivation {
    pname = "peertube";
    inherit version;
    src = source;
    phases = [ "unpackPhase" "patchPhase" "installPhase" ];
    patches = [ ./fix_yarn_lock.patch ];
    installPhase = ''
      mkdir $out
      cp -a . $out/
    '';
  };
  yarnModulesConfig = {
    bcrypt = {
      buildInputs = [ nodePackages.node-pre-gyp ];

      postInstall = let
        bcrypt_version = "5.0.0";
        bcrypt_lib = fetchurl {
          url = "https://github.com/kelektiv/node.bcrypt.js/releases/download/v${bcrypt_version}/bcrypt_lib-v${bcrypt_version}-napi-v3-linux-x64-glibc.tar.gz";
          sha256 = "0j3p2px1xb17sw3gpm8l4apljajxxfflal1yy552mhpzhi21wccn";
        };
      in ''
        if [ "${bcrypt_version}" != "$(cat package.json | ${jq}/bin/jq -r .version)" ]; then
          echo "Mismatching version please update bcrypt in derivation"
          false
        fi
        mkdir -p lib/binding && tar -C lib/binding -xf ${bcrypt_lib}
        patchShebangs ../node-pre-gyp
        npm run install
      '';
    };

    utf-8-validate = {
      buildInputs = [ nodePackages.node-gyp-build ];
    };

    youtube-dl = {
      postInstall = ''
        mkdir bin
        ln -s ${youtube-dl}/bin/youtube-dl bin/youtube-dl
        cat > bin/details <<EOF
        {"version":"${youtube-dl.version}","path":null,"exec":"youtube-dl"}
        EOF
      '';
    };
  };

  mkYarnModulesFixed = args: (yarn2nix-moretea.mkYarnModules args).overrideAttrs(old: {
    # This hack permits to workaround the fact that the yarn.lock
    # file doesn't respect the semver requirements
    buildPhase = builtins.replaceStrings [" ./package.json"] [" /dev/null; cp deps/*/package.json ."] old.buildPhase;
  });

  server = callPackage ./server.nix {
    inherit version yarnModulesConfig mkYarnModulesFixed;
    sources = patchedSource;
  };

  client = callPackage ./client.nix {
    inherit server version yarnModulesConfig mkYarnModulesFixed;
    sources = patchedSource;
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "peertube";
  src = patchedSource;

  buildPhase = ''
    ln -s ${server.modules}/node_modules .
    rm -rf dist && cp -a ${server.dist}/dist dist
    rm -rf client/dist && cp -a ${client.dist}/dist client/
  '';

  installPhase = ''
    mkdir $out
    cp -a * $out
    ln -s /tmp $out/.cache
  '';

  meta = {
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

    license = lib.licenses.agpl3Plus;

    homepage = "https://joinpeertube.org/";
    platforms = lib.platforms.unix;

    maintainers = with lib.maintainers; [ immae stevenroose ];
  };
}

