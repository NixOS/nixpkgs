{ lib, stdenv, llvmPackages }:

let
  clang = llvmPackages.clang-unwrapped;

in stdenv.mkDerivation {
  pname = "clang-tools";
  version = lib.getVersion clang;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    export libc_includes="${lib.getDev stdenv.cc.libc}/include"
    export libcpp_includes="${llvmPackages.libcxx}/include/c++/v1"

    export clang=${clang}
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

  meta = clang.meta // {
    description = "Standalone command line tools for C++ development";
    maintainers = with lib.maintainers; [ aherrmann ];
  };
}
