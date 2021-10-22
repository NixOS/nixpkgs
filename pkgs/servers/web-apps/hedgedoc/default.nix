{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, makeWrapper
, which
, nodejs
, mkYarnPackage
, fetchYarnDeps
, python2
, nixosTests
, buildGoModule
}:

let
  pinData = (builtins.fromJSON (builtins.readFile ./pin.json));

  # we need a different version than the one already available in nixpkgs
  esbuild-hedgedoc = buildGoModule rec {
    pname = "esbuild";
    version = "0.12.27";

    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${version}";
      sha256 = "sha256-UclUTfm6fxoYEEdEEmO/j+WLZLe8SFzt7+Tej4bR0RU=";
    };

    vendorSha256 = "sha256-QPkBR+FscUc3jOvH7olcGUhM6OW4vxawmNJuRQxPuGs=";
  };
in

mkYarnPackage rec {
  pname = "hedgedoc";
  inherit (pinData) version;

  src = fetchFromGitHub {
    owner  = "hedgedoc";
    repo   = "hedgedoc";
    rev    = version;
    sha256 = pinData.srcHash;
  };

  nativeBuildInputs = [ which makeWrapper ];
  extraBuildInputs = [ python2 esbuild-hedgedoc ];

  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    sha256 = pinData.yarnHash;
  };

  # FIXME(@Ma27) on the bump to 1.9.0 I had to patch this file manually:
  # I replaced `midi "https://github.com/paulrosen/MIDI.js.git#abcjs"` with
  # `midi "git+https://github.com/paulrosen/MIDI.js.git#abcjs"` on all occurrences.
  #
  # Without this change `yarn` attempted to download the code directly from GitHub, with
  # the `git+`-prefix it actually uses the `midi.js` version from the offline cache
  # created by `yarn2nix`. On future bumps this may be necessary as well!
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
      --set NODE_PATH "$out/lib/node_modules"

    runHook postDist
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = { inherit (nixosTests) hedgedoc; };
  };

  meta = with lib; {
    description = "Realtime collaborative markdown notes on all platforms";
    license = licenses.agpl3;
    homepage = "https://hedgedoc.org";
    maintainers = with maintainers; [ willibutz ma27 globin ];
    platforms = platforms.linux;
  };
}
