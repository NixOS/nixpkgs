{ ldap ? false, sendmail ? false, light ? null, runCommand, libsass
, lib, stdenv, rsync, fetchzip, youtube-dl, fetchurl, python, nodejs, nodePackages, yarn2nix-moretea
, fetchFromGitHub }:
let
  nodeHeaders = fetchurl {
    url = "https://nodejs.org/download/release/v${nodejs.version}/node-v${nodejs.version}-headers.tar.gz";
    sha256 = "15hkcbs328d3rc1s14rmky8lh8d3rr86l8k0bia0ggxzwl23lj9c";
  };
  source = rec {
    version = "v2.1.1";
    name = "peertube-${version}";
    src = fetchFromGitHub {
      owner = "Chocobozzz";
      repo = "PeerTube";
      rev = "76f7b571c04c03ba422bd5790944fe80dbb24067";
      sha256 = "147gm1j657fkpv2ix1bmkhl7ld5h224q7hgdj9ffj3z14mqgk8hj";
      fetchSubmodules = true;
    };
  };
  patchedSource = stdenv.mkDerivation (source // rec {
    phases = [ "unpackPhase" "patchPhase" "installPhase" ];
    patches = [ ./yarn_fix_http_node.patch ] ++ lib.optionals ldap [ ./ldap.patch ] ++ lib.optionals sendmail [ ./sendmail.patch ];
    installPhase = ''
      mkdir $out
      cp -a . $out/
    '';
  });
  serverPatchedPackage = runCommand "server-package" {} ''
    mkdir -p $out
    cp ${patchedSource}/package.json $out/
    cp ${patchedSource}/yarn.lock $out/
  '';
  clientPatchedPackage = runCommand "client-package" {} ''
    mkdir -p $out
    cp ${patchedSource}/client/package.json $out/
    cp ${patchedSource}/client/yarn.lock $out/
  '';

  yarnModulesConfig = {
    # all = {
    #   buildInputs = [ yarn2nix-moretea.yarn2nix.src ];
    # };
    bcrypt = {
      buildInputs = [ nodePackages.node-pre-gyp ];
      postInstall = let
        bcrypt_lib = fetchurl {
          url = "https://github.com/kelektiv/node.bcrypt.js/releases/download/v3.0.7/bcrypt_lib-v3.0.7-node-v64-linux-x64-glibc.tar.gz";
          sha256 = "0gbq4grhp5wl0f9yqb4y43kjfh8nivfd6y0nkv1x6gfvs2v23wb0";
        };
      in
        ''
          mkdir lib && tar -C lib -xf ${bcrypt_lib}
          patchShebangs ../node-pre-gyp
          npm run install
        '';
    };
    dtrace-provider = {
      buildInputs = [ python nodePackages.node-gyp ];
      postInstall = ''
        npx node-gyp rebuild --tarball=${nodeHeaders}
        '';
    };
    node-sass = {
      buildInputs = [ libsass python ];
      postInstall =
        ''
          node scripts/build.js --tarball=${nodeHeaders}
        '';
    };

    sharp = {
      buildInputs = [ python nodePackages.node-gyp ];
      postInstall =
        let
          tarball = fetchurl {
            url = "https://github.com/lovell/sharp-libvips/releases/download/v8.8.1/libvips-8.8.1-linux-x64.tar.gz";
            sha256 = "0xqv61g6s6rkvc31zq9a3bf8rp56ijnpw0xhr91hc88asqprd5yh";
          };
        in
        ''
          mkdir vendor
          tar -C vendor -xf ${tarball}
          patchShebangs ../prebuild-install
          npx node install/libvips
          npx node install/dll-copy
          npx prebuild-install || npx node-gyp rebuild --tarball=${nodeHeaders}
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
  serverYarnModulesArg = rec {
    pname = "peertube-server-yarn-modules";
    version = source.version;
    name = "${pname}-${version}";
    packageJSON = "${serverPatchedPackage}/package.json";
    yarnLock = "${serverPatchedPackage}/yarn.lock";
    yarnNix = ./server-yarn-packages.nix;
    pkgConfig = yarnModulesConfig;
  };
  clientYarnModulesArg = rec {
    pname = "peertube-client-yarn-modules";
    version = source.version;
    name = "${pname}-${version}";
    packageJSON = "${clientPatchedPackage}/package.json";
    yarnLock = "${clientPatchedPackage}/yarn.lock";
    yarnNix = ./client-yarn-packages.nix;
    pkgConfig = yarnModulesConfig;
  };
  yarnModulesNoWorkspace = args: (yarn2nix-moretea.mkYarnModules args).overrideAttrs(old: {
    buildPhase = builtins.replaceStrings [" ./package.json"] [" /dev/null; cp deps/*/package.json ."] old.buildPhase;
  });

  patchedPackages = stdenv.mkDerivation (source // rec {
    patches = if ldap then [ ./ldap.patch ] else [ ./yarn_fix_http_node.patch ];
    installPhase = ''
      mkdir $out
      cp package.json yarn.lock $out/
      '';
  });
  serverYarnModules = yarnModulesNoWorkspace serverYarnModulesArg;
  serverYarnModulesProd = yarnModulesNoWorkspace (serverYarnModulesArg // { yarnFlags = yarn2nix-moretea.defaultYarnFlags ++ [ "--production" ]; });
  clientYarnModules = yarnModulesNoWorkspace clientYarnModulesArg;

  server = stdenv.mkDerivation ({
    pname = "peertube-server";
    version = source.version;
    src = patchedSource;
    buildPhase = ''
      ln -s ${serverYarnModules}/node_modules .
      npm run build:server
      '';
    installPhase = ''
      mkdir $out
      cp -a dist $out
      '';
    buildInputs = [ nodejs serverYarnModules ];
  });

  client = stdenv.mkDerivation ({
    pname = "peertube-client";
    version = source.version;
    src = patchedSource;
    buildPhase = let
      lightArg = if light == null then "" else if light == true then "--light" else "--light-language";
    in ''
      ln -s ${serverYarnModules}/node_modules .
      cp -a ${clientYarnModules}/node_modules client/
      chmod +w client/node_modules
      patchShebangs .
      npm run build:client -- ${lightArg}
      '';
    installPhase = ''
      mkdir $out
      cp -a client/dist $out
      '';
    buildInputs = [ nodejs clientYarnModules ];
  });

  package = stdenv.mkDerivation rec {
    version = source.version;
    pname = "peertube";
    src = patchedSource;
    buildPhase = ''
      ln -s ${serverYarnModulesProd}/node_modules .
      ln -s ${clientYarnModules}/node_modules client/
      rm -rf dist && cp -a ${server}/dist dist
      rm -rf client/dist && cp -a ${client}/dist client/
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

      license = stdenv.lib.licenses.agpl3Plus;

      homepage = "https://joinpeertube.org/";

      platforms = stdenv.lib.platforms.linux; # not sure here
      maintainers = with stdenv.lib.maintainers; [ matthiasbeyer immae ];
    };
  };
in
  package
