{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "wbox";
  version = "5";

  installPhase = ''
    install -vD wbox "$out/bin/wbox"
  '';

  src = fetchurl {
    url = "http://www.hping.org/wbox/${pname}-${version}.tar.gz";
    sha256 = "06daxwbysppvbh1mwprw8fgsp6mbd3kqj7a978w7ivn8hdgdi28m";
  };

  meta = {
    description = "A simple HTTP benchmarking tool";
    homepage = "http://www.hping.org/wbox/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "wbox";
  };
}
