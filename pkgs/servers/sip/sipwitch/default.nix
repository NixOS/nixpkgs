{ fetchurl, stdenv, pkgconfig, ucommon, libosip, libexosip, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "sipwitch-1.9.15";

  src = fetchurl {
    url = "mirror://gnu/sipwitch/${name}.tar.gz";
    sha256 = "2a7aa86a653f6810b3cd9cce6c37b3f70e937e7d14b09fd5c2a70d70588a9482";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ucommon libosip libexosip gnutls zlib ];

  preConfigure = ''
    export configureFlags="--sysconfdir=$out/etc"
  '';

  doCheck = true;

  meta = {
    description = "Secure peer-to-peer VoIP server that uses the SIP protocol";
    homepage = https://www.gnu.org/software/sipwitch/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
