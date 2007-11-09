{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.17";
  src = 
	fetchurl {
		url = mirror://gnu/tar/tar-1.18.tar.bz2;
		sha256 = "0png2yqkw333acf55k0hjs0mcx1s0w0gkf50pa6hv3kw8bh4x524";
	};
  patches = [./implausible.patch ./gnulib-futimens.patch];
}
