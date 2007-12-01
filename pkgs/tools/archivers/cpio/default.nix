{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cpio-2.9";
  src = fetchurl {
    url = mirror://gnu/cpio/cpio-2.9.tar.bz2;
    sha256 = "01s7f9hg8kgpis96j99hgkiqgdy53pm7qi7bhm3fzx58jfk5z6mv";
  };
}
