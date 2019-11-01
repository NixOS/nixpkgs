{ stdenv, llvmPackages }:

let
  clang = llvmPackages.clang-unwrapped;

in stdenv.mkDerivation {
  pname = "clang-tools";
  version = stdenv.lib.getVersion clang;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for tool in \
      clang-apply-replacements \
      clang-check \
      clang-format \
      clang-rename \
      clang-tidy \
      clangd
    do
      ln -s ${clang}/bin/$tool $out/bin/$tool
    done

    runHook postInstall
  '';

  meta = clang.meta // {
    description = "Standalone command line tools for C++ development";
    maintainers = with stdenv.lib.maintainers; [ aherrmann ];
  };
}
