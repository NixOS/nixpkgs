{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, makeWrapper
, which
, nodejs
, mkYarnPackage
, python2
, nixosTests
, buildGoModule
}:

let
  # we need a different version than the one already available in nixpkgs
  esbuild-hedgedoc = buildGoModule rec {
    pname = "esbuild";
    version = "0.11.20";

    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${version}";
      sha256 = "009f2mfgzkzgxjh3034mzdkcvm5vz17sgy1cs604f0425i22z8qm";
    };

    vendorSha256 = "1n5538yik72x94vzfq31qaqrkpxds5xys1wlibw2gn2am0z5c06q";
  };
in

mkYarnPackage rec {
  name = "hedgedoc";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner  = "hedgedoc";
    repo   = "hedgedoc";
    rev    = version;
    sha256 = "1h2wyhap264iqm2jh0i05w0hb2j86jsq1plyl7k3an90w7wngyg1";
  };

  nativeBuildInputs = [ which makeWrapper ];
  extraBuildInputs = [ python2 esbuild-hedgedoc ];

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

    pushd node_modules/esbuild
    rm bin/esbuild
    ln -s ${lib.getBin esbuild-hedgedoc}/bin/esbuild bin/
    popd

    npm run build

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
      --set NODE_PATH "$out/node_modules"

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
