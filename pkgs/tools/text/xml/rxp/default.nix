{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "rxp-1.2.3";
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/r/rxp/rxp_1.2.3.orig.tar.gz;
    sha256 = "1r4khvmnl5231y37ji8f3mikxy0dhdz155wi3qihfi27mc1yv534";
  };
  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  installPhase = ''
    mkdir -p $out/bin
    cp rxp $out/bin
  '';
  meta = {
    license = "GPL";
    description = "a validating XML parser written in C";
    homepage = "http://www.cogsci.ed.ac.uk/~richard/rxp.html";
  };
}
