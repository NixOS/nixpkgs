{ stdenv, writeScript, llvmPackages }:

let
  clang = llvmPackages.clang-unwrapped;
  version = stdenv.lib.getVersion clang;
in

stdenv.mkDerivation {
  name = "clang-tools-${version}";
  unpackPhase = ":";
  installPhase = ''
    mkdir -p $out/bin
    for tool in \
      clang-apply-replacements \
      clang-check \
      clang-format \
      clang-rename \
      clang-tidy
    do
      ln -s ${clang}/bin/$tool $out/bin/$tool
    done
  '';
  meta = clang.meta // {
    description = "Standalone command line tools for C++ development";
    maintainers = with stdenv.lib.maintainers; [ aherrmann ];
  };
}
