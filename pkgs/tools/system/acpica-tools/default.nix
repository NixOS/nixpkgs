{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "acpica-tools-${version}";
  version = "20190509";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "06k22kfnjzf3mpvrb7xl2pfnh28q3n8wcgdjchl1j2hik5pan97i";
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
