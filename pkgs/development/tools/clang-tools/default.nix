{ stdenv, makeWrapper, writeScript, llvmPackages }:

let
  clang = llvmPackages.clang-unwrapped;
  version = stdenv.lib.getVersion clang;
in

stdenv.mkDerivation {
  name = "clang-tools-${version}";
  builder = writeScript "builder" ''
    source $stdenv/setup
    for tool in \
      clang-apply-replacements \
      clang-check \
      clang-format \
      clang-rename \
      clang-tidy
    do
      makeWrapper $clang/bin/$tool $out/bin/$tool --argv0 $tool
    done
  '';
  buildInputs = [ makeWrapper ];
  inherit clang;
  meta = clang.meta // {
    description = "Standalone command line tools for C++ development";
    maintainers = with stdenv.lib.maintainers; [ aherrmann ];
  };
}
