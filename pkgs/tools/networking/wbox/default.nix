{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wbox-${version}";
  version = "5";

  installPhase = ''
    install -vD wbox "$out/bin/wbox"
  '';

  src = fetchurl {
    url = "http://www.hping.org/wbox/${name}.tar.gz";
    sha256 = "06daxwbysppvbh1mwprw8fgsp6mbd3kqj7a978w7ivn8hdgdi28m";
  };

  meta = {
    description = "A simple HTTP benchmarking tool";
    homepage = "http://www.hping.org/wbox/";
    license = stdenv.lib.licenses.bsd3;
  };
}
