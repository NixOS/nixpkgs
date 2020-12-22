{ stdenv, fetchFromGitHub, fetchpatch, makeWrapper
, which, nodejs, mkYarnPackage, python2, nixosTests }:

mkYarnPackage rec {
  name = "hedgedoc";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner  = "hedgedoc";
    repo   = "hedgedoc";
    rev    = version;
    sha256 = "1zz5ni9cp1dhcvcrzks13pww5qm2wna2hh0k59pfz7c897rs1l7v";
  };

  nativeBuildInputs = [ which makeWrapper ];
  extraBuildInputs = [ python2 ];

  yarnNix = ./yarn.nix;
  yarnLock = ./yarn.lock;
  packageJSON = ./package.json;

  postConfigure = ''
    rm deps/HedgeDoc/node_modules
    cp -R "$node_modules" deps/HedgeDoc
    chmod -R u+w deps/HedgeDoc
  '';

  buildPhase = ''
    runHook preBuild

    cd deps/HedgeDoc

    pushd node_modules/sqlite3
    export CPPFLAGS="-I${nodejs}/include/node"
    npm run install --build-from-source --nodedir=${nodejs}/include/node
    popd

    npm run build

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

  passthru.tests = { inherit (nixosTests) hedgedoc; };

  meta = with stdenv.lib; {
    description = "Realtime collaborative markdown notes on all platforms";
    license = licenses.agpl3;
    homepage = "https://hedgedoc.org";
    maintainers = with maintainers; [ willibutz ma27 globin ];
    platforms = platforms.linux;
  };
}
