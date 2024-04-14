{
  stdenv,
  ghc,
  lib,
}:

stdenv.mkDerivation {
  pname = "ghc-settings-edit";
  version = "0.1.0";
  # See the source code for an explanation
  src = ./ghc-settings-edit.lhs;
  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ ghc ];
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    ${ghc.targetPrefix}ghc --make "$src" -o "$out/bin/ghc-settings-edit"

    runHook postInstall
  '';

  meta = {
    license = [
      lib.licenses.mit
      lib.licenses.bsd3
    ];
    platforms = lib.platforms.all;
    description = "Tool for editing GHC's settings file";
  };
}
