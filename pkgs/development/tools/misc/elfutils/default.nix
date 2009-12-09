{stdenv, fetchurl, m4}:

stdenv.mkDerivation rec {
  name = "elfutils-0.143";
  
  src = fetchurl {
    url = "https://fedorahosted.org/releases/e/l/elfutils/${name}.tar.bz2";
    sha256 = "1zrqs93m6frg7j70a96xdhdb4mnzmqgh91f9bbm39jnmgs50qp23";
  };

  buildInputs = [m4];
  
  dontAddDisableDepTrack = true;

  meta = {
    homepage = https://fedorahosted.org/elfutils/;
  };
}
