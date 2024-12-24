{
  lib,
  stdenv,
  clang,
  llvmPackages,
  perl,
  makeWrapper,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "clang-analyzer";
  inherit (llvmPackages.clang-unwrapped) src version;

  patches = [ ./0001-Fix-scan-build-to-use-NIX_CFLAGS_COMPILE.patch ];
  buildInputs = [
    clang
    llvmPackages.clang
    perl
    python3
  ];
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/scan-view $out/bin
    cp -R clang/tools/scan-view/share/* $out/share/scan-view
    cp -R clang/tools/scan-view/bin/* $out/bin/scan-view
    cp -R clang/tools/scan-build/* $out

    rm $out/bin/*.bat $out/libexec/*.bat $out/CMakeLists.txt

    wrapProgram $out/bin/scan-build \
      --add-flags "--use-cc=${clang}/bin/clang" \
      --add-flags "--use-c++=${clang}/bin/clang++" \
      --add-flags "--use-analyzer='${llvmPackages.clang}/bin/clang'"
  '';

  meta = {
    description = "Clang Static Analyzer";
    longDescription = ''
      The Clang Static Analyzer is a source code analysis tool that finds bugs
      in C, C++, and Objective-C programs.
    '';
    homepage = "https://clang-analyzer.llvm.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
