args: with args;

stdenv.mkDerivation rec {
  name = "gdb-6.7.1";
  src = fetchurl {
    url = "mirror://gnu/gdb/${name}.tar.bz2";
	sha256 = "0qig8j8hcqpqfhnnp685rzgj8v88bw2fc5igvbiiqkqg88wfr37r";
  };
  buildInputs = [ncurses];
}
