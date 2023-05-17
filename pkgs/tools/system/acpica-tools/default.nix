{ lib
, stdenv
, fetchurl
, bison
, flex
}:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20230331";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    hash = "sha256-DF1pXWBaqmFwnzxj9XoambiQIpFyOZhEawgTtXrDEOI=";
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

  env.NIX_CFLAGS_COMPILE = toString ([
    "-O3"
  ] ++ lib.optionals (stdenv.cc.isGNU) [
    # Needed with GCC 12
    "-Wno-dangling-pointer"
  ]);

  enableParallelBuilding = true;

  # i686 builds fail with hardening enabled (due to -Wformat-overflow). Disable
  # -Werror altogether to make this derivation less fragile to toolchain
  # updates.
  NOWERROR = "TRUE";

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
