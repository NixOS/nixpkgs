{ stdenv, lib, fetchurl, gnugrep, p7zip }:

# https://sourceforge.net/p/sevenzip/discussion/45797/thread/7fe6c21efa/
stdenv.mkDerivation rec {
  pname = "7zz";
  version = "21.02";

  src = fetchurl {
    url = "https://7-zip.org/a/7z${lib.replaceStrings ["." ] [""] version}-src.7z";
    sha256 = "sha256-7pdV/qoDTnB1cSvGsfrSVEC9Co8h8Qahbje8S0CfESI=";
  };

  sourceRoot = "CPP/7zip/Bundles/Alone2";

  # we need https://github.com/nidud/asmc/tree/master/source/asmc/linux in order
  # to build with the optimized assembler but that doesn't support building with
  # GCC
  # "../../cmpl_gcc_x64.mak";
  makefile = "../../cmpl_gcc.mak";

  NIX_CFLAGS_COMPILE = [ "-Wno-error=maybe-uninitialized" ];

  nativeBuildInputs = [ gnugrep p7zip ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm555 -t $out/bin b/g/7zz
    install -Dm444 -t $out/share/doc/${pname} ../../../../DOC/*.txt
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/7zz --help | grep ${version}
  '';

  meta = with lib; {
    description = "Command line archiver utility";
    homepage = "https://7zip.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ anna328p peterhoeg ];
    platforms = platforms.linux;
  };
}
