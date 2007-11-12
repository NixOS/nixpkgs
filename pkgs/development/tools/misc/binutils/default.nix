{stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation {
  name = "binutils-2.18";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://gnu/binutils/binutils-2.18.tar.bz2;
    sha256 = "16zfc7llbjdn69bbdy7kqgg2xa67ypgj7z5qicgwzvghaaj36yj8";
  };
  inherit noSysDirs;
  configureFlags = "--disable-werror"; # needed for dietlibc build

  meta = {
    description = "Tools for manipulating binaries (linker, assembler, etc.)";

    /* Give binutils a lower priority than gcc-wrapper to prevent a
       collision due to the ld/as wrappers/symlinks in the latter. */
    priority = "10";
  };
}
