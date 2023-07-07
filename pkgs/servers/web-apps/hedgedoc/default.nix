{ lib
, stdenv
, fetchzip
, makeWrapper
, which
, nodejs
, mkYarnPackage
, fetchYarnDeps
, python3
, nixosTests
}:

mkYarnPackage rec {
  pname = "hedgedoc";
  version = "1.9.7";

  # we use the upstream compiled js files because yarn2nix cannot handle different versions of dependencies
  # in development and production and the web assets muts be compiled with js-yaml 3 while development
  # uses js-yaml 4 which breaks the text editor
  src = fetchzip {
    url = "https://github.com/hedgedoc/hedgedoc/releases/download/${version}/hedgedoc-${version}.tar.gz";
    hash = "sha256-tPkhnnKDS5TICsW66YCOy7xWFj5usLyDMbYMYQ3Euoc=";
  };

  nativeBuildInputs = [ which makeWrapper ];
  extraBuildInputs = [ python3 ];

  packageJSON = ./package.json;
  yarnFlags = [ "--production" ];

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "0qkc26ks33vy00jgpv4445wzgxx1mzi70pkm1l8y9amgd9wf9aig";
  };

  configurePhase = ''
    cp -r "$node_modules" node_modules
    chmod -R u+w node_modules
  '';

  buildPhase = ''
    runHook preBuild

    pushd node_modules/sqlite3
    export CPPFLAGS="-I${nodejs}/include/node"
    npm run install --build-from-source --nodedir=${nodejs}/include/node
    popd

    patchShebangs bin/*

    runHook postBuild
  '';

  dontInstall = true;

  distPhase = ''
    runHook preDist

    mkdir -p $out
    cp -R {app.js,bin,lib,locales,node_modules,package.json,public} $out

    cat > $out/bin/hedgedoc <<EOF
      #!${stdenv.shell}/bin/sh
      ${nodejs}/bin/node $out/app.js
    EOF
    chmod +x $out/bin/hedgedoc
    wrapProgram $out/bin/hedgedoc \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postDist
  '';

  passthru = {
    tests = { inherit (nixosTests) hedgedoc; };
  };

  meta = with lib; {
    description = "Realtime collaborative markdown notes on all platforms";
    license = licenses.agpl3;
    homepage = "https://hedgedoc.org";
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.linux;
  };
}
