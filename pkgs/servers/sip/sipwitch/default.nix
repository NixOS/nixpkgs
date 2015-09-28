{ fetchurl, stdenv, pkgconfig, ucommon, libosip, libexosip, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "sipwitch-1.9.8";

  src = fetchurl {
    url = "mirror://gnu/sipwitch/${name}.tar.gz";
    sha256 = "0117c5iid1vrwl7sl3pys2jlinpmx2vfp8wcdwk93m7cc6k9793b";
  };

  buildInputs = [ pkgconfig ucommon libosip libexosip gnutls zlib ];

  preConfigure = ''
    export configureFlags="--sysconfdir=$out/etc"
  '';

  doCheck = true;

  meta = {
    description = "Secure peer-to-peer VoIP server that uses the SIP protocol";
    homepage = http://www.gnu.org/software/sipwitch/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
