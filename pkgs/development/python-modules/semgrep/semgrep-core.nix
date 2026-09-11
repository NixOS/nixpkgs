{
  lib,
  stdenv,
  fetchPypi,

  patchelf,
  unzip,
}:

let
  common = import ./common.nix { inherit lib; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "semgrep-core";
  inherit (common) version;

  __structuredAttrs = true;
  strictDeps = true;

  # fetch pre-built semgrep-core since the ocaml build is complex and relies on
  # the opam package manager at some point
  # pulling it out of the python wheel as r2c no longer release a built binary
  # on github releases
  src =
    let
      inherit (stdenv.hostPlatform) system;
      data = common.core.${system} or (throw "Unsupported system: ${system}");
      python = common.pythonWheelTag;
    in
    fetchPypi {
      pname = "semgrep";
      inherit (finalAttrs) version;
      format = "wheel";
      dist = python;
      inherit python;
      inherit (data) platform hash;
    };

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    patchelf
  ];

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
    install -Dm 755 -t $out/bin semgrep-${finalAttrs.version}.data/purelib/semgrep/bin/semgrep-core

    # copy bundled libs as well
    # keeping them in bin/libs matches the layout in the wheel
    if [ -d semgrep-${finalAttrs.version}.data/purelib/semgrep/bin/libs ]; then
      mkdir -p $out/bin/libs
      cp -rf semgrep-${finalAttrs.version}.data/purelib/semgrep/bin/libs/* $out/bin/libs/
    fi
    runHook postInstall
  '';

  # Multiple rewrites of this large binary corrupt it on aarch64: patchelf leaves `.dynstr`
  # outside any loadable segment, so ld.so segfaults reading the rpath at startup (patchelf bug,
  # see https://github.com/NixOS/patchelf/issues/244). So we avoid autoPatchelfHook, disable
  # stdenv's own `strip` and `patchelf --shrink-rpath`, and fix the interpreter and rpath in a
  # single patchelf call below. The bundled bin/libs reference each other via $ORIGIN, so only the
  # main binary needs it.
  dontPatchELF = true;
  dontStrip = true;
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf \
      --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
      --set-rpath "$out/bin/libs:${lib.makeLibraryPath [ stdenv.cc.libc ]}" \
      $out/bin/semgrep-core
  '';

  meta = common.meta // {
    description = common.meta.description + " - core binary";
    mainProgram = "semgrep-core";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames common.core;
  };
})
