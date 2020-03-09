{ stdenv, fetchhg, openssl, pcre-cpp, qt4, boost, pkcs11helper }:

stdenv.mkDerivation {
  name = "meo-20121113";
  
  src = fetchhg {
    url = http://oss.stamfest.net/hg/meo;
    rev = "b48e5f16cff8";
    sha256 = "0ifg7y28s89i9gwda6fyj1jbrykbcvq8bf1m6rxmdcv5afi3arbq";
  };

  buildFlags = [ "QMAKE=qmake" ];

  buildInputs = [ openssl pcre-cpp qt4 boost pkcs11helper ];

  preConfigure = ''
    sed -i s,-mt$,, meo-gui/meo-gui.pro
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tools/{meo,p11} $out/bin
    cp meo-gui/meo-gui $out/bin
    cp meo-gui/meo-gui $out/bin
  '';

  meta = {
    homepage = http://oss.stamfest.net/wordpress/meo-multiple-eyepairs-only;
    description = "Tools to use cryptography for things like four-eyes principles";
    license = stdenv.lib.licenses.agpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    broken = true;
  };
}
