{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20190703";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "031m124a109vv6fx667h4ca2iav0xszrlvif9zcfxcaxbjsn6991";
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
