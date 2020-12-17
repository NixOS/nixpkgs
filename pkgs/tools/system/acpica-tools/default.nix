{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20200925";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "12a5hd7wfwm0rcfjfxpc9zq7bxyk6mwqk74ysg34fbix3vi8hhyl";
  };

  NIX_CFLAGS_COMPILE = "-O3";

  enableParallelBuilding = true;

  buildFlags = [
    "acpibin"
    "acpidump"
    "acpiexec"
    "acpihelp"
    "acpixtract"
    "iasl"
  ];

  nativeBuildInputs = [ bison flex ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "ACPICA Tools";
    homepage = "https://www.acpica.org/";
    license = with licenses; [ gpl2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tadfisher ];
  };
}
