{ stdenv, fetchFromGitHub, fetchpatch, makeWrapper
, which, nodejs, mkYarnPackage, python2 }:

mkYarnPackage rec {
  name = "codimd";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner  = "codimd";
    repo   = "server";
    rev    = version;
    sha256 = "1208a24v664ha9qzr7ky6i3ynphkaj0xi5l3rsw743i22nv5aj33";
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
