{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "cccc";
  version = "3.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/cccc/${version}/cccc-${version}.tar.gz";
    sha256 = "1gsdzzisrk95kajs3gfxks3bjvfd9g680fin6a9pjrism2lyrcr7";
  };

  hardeningDisable = [ "format" ];

  patches = [ ./cccc.patch ];

  preConfigure = ''
    substituteInPlace install/install.mak --replace /usr/local/bin $out/bin
    substituteInPlace install/install.mak --replace MKDIR=mkdir "MKDIR=mkdir -p"
  '';
  buildFlags = [
    "CCC=c++"
    "LD=c++"
  ];

  meta = {
    description = "C and C++ Code Counter";
    mainProgram = "cccc";
    longDescription = ''
      CCCC is a tool which analyzes C++ and Java files and generates a report
      on various metrics of the code. Metrics supported include lines of code, McCabe's
      complexity and metrics proposed by Chidamber&Kemerer and Henry&Kafura.
    '';
    homepage = "https://cccc.sourceforge.net/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.linquize ];
  };
}
