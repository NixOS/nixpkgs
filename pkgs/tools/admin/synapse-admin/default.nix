{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, mkYarnPackage
, baseUrl ? null
}:

mkYarnPackage rec {
  pname = "synapse-admin";
  version = "0.8.5";
  src = fetchFromGitHub {
    owner = "Awesome-Technologies";
    repo = pname;
    rev = version;
    sha256 = "sha256-0miHtEJ5e8MaqGc4ezPvwhGjoCZyOE7md0DUCC/ZOfk=";
  };

  yarnNix = ./yarn.nix;
  yarnLock = ./yarn.lock;
  packageJSON = ./package.json;

  NODE_ENV = "production";
  ${if baseUrl != null then "REACT_APP_SERVER" else null} = baseUrl;

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    pushd deps/synapse-admin
    mv node_modules node_modules.bak
    cp -r $(readlink -f node_modules.bak) node_modules
    chmod +w node_modules
    yarn --offline run build
    popd

    runHook postBuild
  '';

  distPhase = ''
    runHook preDist

    mkdir -p $out
    cp -r deps/synapse-admin/build/* $out

    runHook postDist
  '';

  dontFixup = true;
  dontInstall = true;

  meta = with lib; {
    description = "Admin UI for Synapse Homeservers";
    homepage = "https://github.com/Awesome-Technologies/synapse-admin";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ma27 ];
  };
}
