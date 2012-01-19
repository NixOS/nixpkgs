{ fetchurl, stdenv, pkgconfig, ucommon, libosip, libexosip, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "sipwitch-1.2.1";

  src = fetchurl {
    url = "mirror://gnu/sipwitch/${name}.tar.gz";
    sha256 = "01364q67gyxpxx5fxrmf9kns3qgivnp41kzhi81jdq8sa48c7qbq";
  };

  buildInputs = [ pkgconfig ucommon libosip libexosip gnutls zlib ];

  preConfigure = ''
    export configureFlags="--sysconfdir=$out/etc"
  '';

  doCheck = true;

  meta = {
    description = "Secure peer-to-peer VoIP server that uses the SIP protocol";
    homepage = http://www.gnu.org/software/sipwitch/;
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
