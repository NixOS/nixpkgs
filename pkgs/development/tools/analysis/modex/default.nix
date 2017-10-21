{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  version = "2.10";
  name = "modex-${version}";

  src = fetchurl {
    url = "http://spinroot.com/modex/modex${version}.tar.gz";
    sha256 = "1iz41w926jgx7b42cmfv7v3i4qwdldababqv60f54bisvrq7psws";
  };

  preConfigure = ''
    substituteInPlace makefile --replace /usr/local/modex $out/share/modex
    substituteInPlace makefile --replace /usr/local $out
    substituteInPlace xtract.c --replace /usr/local $out/share
    '';

  sourceRoot = "Src2.10";

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/modex/Examples
    mkdir -p $out/share/modex/Manual
    '';

  postInstall = ''
    install -m755 ../Scripts/verify $out/bin/
    install -m644 ../Examples/* $out/share/modex/Examples/
    install -m644 ../Manual/* $out/share/modex/Manual/
    '';
  
  buildInputs = [ bison flex ];

  meta = {
    description = "Mechanical extraction of verification models from implementation level C code for spin";
    platforms = stdenv.lib.platforms.linux;
    license = {
      fullName = "Educational, notice must be maintained, non-monetizable";
      location = "tarball extracted $sourceRoot/modex.c";
      free = true;
    };
    homepage = "http://spinroot.com/modex";
    maintainers = [ stdenv.lib.maintainers.kquick ];
  };
}
