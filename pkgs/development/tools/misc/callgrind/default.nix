{stdenv, fetchurl, which, perl, valgrind}:

stdenv.mkDerivation {
  name = "callgrind-0.10.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/callgrind-0.10.1.tar.bz2;
    md5 = "6d8acca6b58b0b72804339d04426d550";
  };

  # Callgrind wants to install in the same prefix as Valgrind.  This
  # patch fixes that.
  patches = [./prefix.patch];

  buildInputs = [which perl valgrind];
  inherit valgrind;
}
