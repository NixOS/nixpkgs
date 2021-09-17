{ lib
, mkYarnPackage
, libsass
, nodejs
, python3
, pkg-config
, writeShellScriptBin
, fetchFromGitHub
}:

let
  pkgConfig = {
    node-sass = {
      nativeBuildInputs = [ ];
      buildInputs = [ libsass pkg-config python3 ];
      postInstall = ''
        LIBSASS_EXT=auto yarn --offline run build
        rm build/config.gypi
      '';
    };
  };

  name = "lemmy-ui";
  version = "0.12.2";
  unwrapped = mkYarnPackage {

    src = fetchFromGitHub {
      owner = "LemmyNet";
      repo = name;
      rev = version;
      fetchSubmodules = true;
      sha256 = "sha256-iFLJqUnz4m9/JTSaJSUugzY5KkiKtH0sMYY4ALm2Ebk=";
    };

    inherit pkgConfig name version;

    extraBuildInputs = [ libsass ];

    yarnNix = ./yarn.nix;

    # Fails mysteriously on source/package.json
    # Upstream package.json is missing a newline at the end
    packageJSON = ./package.json;

    yarnPreBuild = ''
      export npm_config_nodedir=${nodejs}
    '';

    buildPhase = ''
      # Yarn writes cache directories etc to $HOME.
      export HOME=$PWD/yarn_home

      ln -sf $PWD/node_modules $PWD/deps/lemmy-ui/

      yarn --offline build:prod
    '';

    distPhase = "true";

    meta = with lib; {
      description = "Building a federated alternative to reddit in rust";
      homepage = "https://join-lemmy.org/";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ happysalada billewanick ];
      platforms = platforms.linux;
    };
  };
in
(writeShellScriptBin "lemmy-ui" ''
  ${nodejs}/bin/node ${unwrapped}/libexec/lemmy-ui/node_modules/lemmy-ui/dist/js/server.js
'').overrideAttrs (oldAttrs: {
  passthru = { inherit unwrapped; };
})

