{ lib
, stdenv
, fetchurl
, bison
, flex
}:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20220331";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    hash = "sha256-rK/2ixTx4IBOu/xLlyaKTMvvz6BTsC7Zkk8rFNipjiE=";
  };

  nativeBuildInputs = [ bison flex ];

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

  NIX_CFLAGS_COMPILE = "-O3";

  enableParallelBuilding = true;

  # We can handle stripping ourselves.
  # Unless we are on Darwin. Upstream makefiles degrade coreutils install to cp if _APPLE is detected.
  INSTALLFLAGS = lib.optionals (!stdenv.isDarwin) "-m 555";

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://www.acpica.org/";
    description = "ACPICA Tools";
    license = with licenses; [ iasl gpl2Only bsd3 ];
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
