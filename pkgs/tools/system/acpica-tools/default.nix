{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20191018";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "0pz95fb1zvsj9238bg7a4vxl1svn5mnjg10sn5qvgr008q0v9782";
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

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "ACPICA Tools";
    homepage = "https://www.acpica.org/";
    license = with licenses; [ gpl2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tadfisher ];
  };
}
