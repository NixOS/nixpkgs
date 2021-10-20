{ lib, stdenv, llvmPackages }:

let
  unwrapped = llvmPackages.clang-unwrapped;

in stdenv.mkDerivation {
  pname = "clang-tools";
  version = lib.getVersion unwrapped;

  dontUnpack = true;

  clang = llvmPackages.clang;
  inherit unwrapped;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    substituteAll ${./wrapper} $out/bin/clangd
    chmod +x $out/bin/clangd
    for tool in \
      clang-apply-replacements \
      clang-check \
      clang-format \
      clang-rename \
      clang-tidy
    do
      ln -s $out/bin/clangd $out/bin/$tool
    done

    runHook postInstall
  '';

  meta = unwrapped.meta // {
    description = "Standalone command line tools for C++ development";
    maintainers = with lib.maintainers; [ aherrmann ];
  };
}
