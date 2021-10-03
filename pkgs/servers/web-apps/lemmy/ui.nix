{ lib
, mkYarnPackage
, libsass
, nodejs
, python3
, pkg-config
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
in
mkYarnPackage {

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

  preInstall = ''
    mkdir $out
    cp -R ./deps/lemmy-ui/dist/assets $out
  '';

  distPhase = "true";

  meta = with lib; {
    description = "Building a federated alternative to reddit in rust";
    homepage = "https://join-lemmy.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada billewanick ];
    platforms = platforms.linux;
  };
}

