{ lib, stdenvNoCC, fetchPypi, unzip }:

let
  common = import ./common.nix { inherit lib; };
in
stdenvNoCC.mkDerivation rec {
  pname = "semgrep-core";
  inherit (common) version;
  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      data = common.core.${system} or (throw "Unsupported system: ${system}");
    in
    fetchPypi rec {
      pname = "semgrep";
      inherit version;
      format = "wheel";
      dist = python;
      python = "cp37.cp38.cp39.py37.py38.py39";
      inherit (data) platform hash;
    };

  nativeBuildInputs = [ unzip ];

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
    runHook postInstall
  '';

  meta = common.meta // {
    description = common.meta.description + " - core binary";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames common.core;
  };
}
