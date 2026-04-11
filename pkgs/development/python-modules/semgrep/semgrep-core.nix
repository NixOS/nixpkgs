{
  lib,
  stdenv,
  fetchPypi,
  unzip,
  autoPatchelfHook,
}:

let
  common = import ./common.nix { inherit lib; };
in
stdenv.mkDerivation rec {
  pname = "semgrep-core";
  inherit (common) version;

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  src =
    let
      inherit (stdenv.hostPlatform) system;
      data = common.core.${system} or (throw "Unsupported system: ${system}");
    in
    fetchPypi rec {
      pname = "semgrep";
      inherit version;
      format = "wheel";
      dist = python;
      python = common.pythonWheelTag;
      inherit (data) platform hash;
    };

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = lib.optional stdenv.hostPlatform.isLinux stdenv.cc.cc.lib;

  # _tryUnzip from unzip's setup-hook doesn't recognise .whl
  # "do not know how to unpack source archive"
  # perform unpack by hand
  unpackPhase = ''
    runHook preUnpack
    LANG=en_US.UTF-8 unzip -qq "$src"
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm 755 -t $out/bin semgrep-${version}.data/purelib/semgrep/bin/semgrep-core

    # copy bundled libs as well
    # keeping them in bin/libs matches the layout in the wheel
    if [ -d semgrep-${version}.data/purelib/semgrep/bin/libs ]; then
      mkdir -p $out/bin/libs
      cp -rf semgrep-${version}.data/purelib/semgrep/bin/libs/* $out/bin/libs/

      # help autoPatchelfHook find these libs
      if [ -n "''${autoPatchelfHook:-}" ]; then
        appendAutoPatchelfSearchPath $out/bin/libs
      fi
    fi
    runHook postInstall
  '';

  meta = common.meta // {
    description = common.meta.description + " - core binary";
    mainProgram = "semgrep-core";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames common.core;
  };
}
