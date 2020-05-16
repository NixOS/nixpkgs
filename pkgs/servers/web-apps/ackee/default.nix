{ lib
, nixosTests
, stdenv
, fetchFromGitHub
, makeWrapper
, mkYarnPackage
, nodejs
}:

mkYarnPackage rec {
  pname = "ackee";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "electerious";
    repo = "Ackee";
    rev = "v${version}";
    sha256 = "f02oL36i9CeJz/3PEiAZJQgNhXMuO6/k+k+83jomZdI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  packageJSON = ./package.json;
  yarnLock = "${src}/yarn.lock";
  yarnNix = ./yarn.nix;

  dontInstall = true;

  prePatch = ''
    for f in src/types/index.js src/resolvers/index.js; do
      substituteInPlace $f --replace 'graphql-tools' '@graphql-tools/merge'
    done
  '';

  postConfigure = ''
    rm deps/ackee/node_modules
    cp -R "$node_modules" deps/ackee
    chmod -R u+w deps/ackee
  '';

  buildPhase = ''
    runHook preBuild

    cd deps/ackee
    npm run build

    runHook postBuild
  '';

  distPhase = ''
    runHook preDist

    mkdir -p $out/bin
    cp -R {src,dist,node_modules,package.json} $out

    makeWrapper ${nodejs}/bin/node $out/bin/ackee \
      --set NODE_PATH "$out/node_modules" \
      --add-flags "$out/src/index.js"

    runHook postDist
  '';

  passthru.tests = { inherit (nixosTests) ackee; };

  meta = with lib; {
    description = "Self-hosted, Node.js based analytics tool for those who care about privacy";
    license = licenses.mit;
    homepage = "https://ackee.electerious.com";
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
  };
}
