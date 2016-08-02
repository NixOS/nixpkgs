{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "netselect-0.3";
  
  src = fetchurl {
    url = http://alumnit.ca/~apenwarr/netselect/netselect-0.3.tar.gz;
    sha256 = "0y69z59vylj9x9nk5jqn6ihx7dkzg09gpv2w1q1rs8fmi4jr90gy";
  };

  preBuild = "
    makeFlagsArray=(PREFIX=$out)
    substituteInPlace Makefile --replace '-o root' '' --replace '-g root' ''
  ";
  
  meta = {
    homepage = http://alumnit.ca/~apenwarr/netselect/;
    description = "An ultrafast intelligent parallelizing binary-search implementation of \"ping\"";
    license = "BSD";
    platforms = stdenv.lib.platforms.linux;
  };
}
