{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "acpica-tools-${version}";
  version = "20180427";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "05hczn82dpn7irh8zy9m17hm8r3ngwrbmk69zsldr4k1w3cv40df";
  };

  NIX_CFLAGS_COMPILE = "-O3";

  enableParallelBuilding = true;

  buildFlags = [
    "acpibin"
    "acpidump"
    "acpiexec"
    "acpihelp"
    "acpinames"
    "acpixtract"
  ];

  nativeBuildInputs = [ bison flex ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "ACPICA Tools";
    homepage = "https://www.acpica.org/";
    license = with licenses; [ gpl2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tadfisher ];
  };
}
