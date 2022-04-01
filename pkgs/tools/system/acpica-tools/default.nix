{ lib, stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20220331";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "sha256-rK/2ixTx4IBOu/xLlyaKTMvvz6BTsC7Zkk8rFNipjiE=";
  };

  NIX_CFLAGS_COMPILE = "-O3";

  enableParallelBuilding = true;

  buildFlags = [
    "acpibin"
    "acpidump"
    "acpiexamples"
    "acpiexec"
    "acpihelp"
    "acpisrc"
    "acpixtract"
    "iasl"
  ];

  nativeBuildInputs = [ bison flex ];

  # We can handle stripping ourselves.
  INSTALLFLAGS = "-m 555";

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "ACPICA Tools";
    homepage = "https://www.acpica.org/";
    license = with licenses; [ iasl gpl2Only bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tadfisher ];
  };
}
