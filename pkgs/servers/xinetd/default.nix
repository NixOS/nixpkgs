{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "xinetd-2.3.14";
  
  src = fetchurl {
    url = "http://www.xinetd.org/${name}.tar.gz";
    sha256 = "07xws1ydxrrx4xinvfqkc66diwfjh2apxz33xw4hb6k0gihhw3kn";
  };

  meta = {
    description = "Secure replacement for inetd";
    platforms = stdenv.lib.platforms.linux;
    homepage = http://xinetd.org;
    license = "free";
  };
}
