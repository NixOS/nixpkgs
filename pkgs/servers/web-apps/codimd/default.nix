{ stdenv, fetchFromGitHub, fetchpatch, makeWrapper
, which, nodejs, yarn2nix, python2 }:

yarn2nix.mkYarnPackage rec {
  name = "codimd";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner  = "codimd";
    repo   = "server";
    rev    = version;
    sha256 = "1sd7r5ws1k7dxmr57m67c1k23pzbkn25k2wvcnbrqn7gza6mhlf0";
  };

  nativeBuildInputs = [ which makeWrapper ];
  extraBuildInputs = [ python2 ];

  yarnNix = ./yarn.nix;
  yarnLock = ./yarn.lock;
  packageJSON = ./package.json;

  postConfigure = ''
    rm deps/CodiMD/node_modules
    cp -R "$node_modules" deps/CodiMD
    chmod -R u+w deps/CodiMD
  '';

  buildPhase = ''
    runHook preBuild

    cd deps/CodiMD

    pushd node_modules/codemirror
    npm run install
    popd

    pushd node_modules/sqlite3
    export OLD_HOME="$HOME"
    export HOME="$PWD"
    mkdir -p .node-gyp/${nodejs.version}
    echo 9 > .node-gyp/${nodejs.version}/installVersion
    ln -s ${nodejs}/include .node-gyp/${nodejs.version}
    npm run install
    export HOME="$OLD_HOME"
    unset OLD_HOME
    popd

    npm run build

    runHook postBuild
  '';

  dontInstall = true;

  distPhase = ''
    runHook preDist

    mkdir -p $out
    cp -R {app.js,bin,lib,locales,node_modules,package.json,public} $out

    cat > $out/bin/codimd <<EOF
      #!${stdenv.shell}/bin/sh
      ${nodejs}/bin/node $out/app.js
    EOF
    chmod +x $out/bin/codimd
    wrapProgram $out/bin/codimd \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postDist
  '';

  meta = with stdenv.lib; {
    description = "Realtime collaborative markdown notes on all platforms";
    license = licenses.agpl3;
    homepage = "https://github.com/codimd/server";
    maintainers = with maintainers; [ willibutz ma27 globin ];
    platforms = platforms.linux;
  };
}
