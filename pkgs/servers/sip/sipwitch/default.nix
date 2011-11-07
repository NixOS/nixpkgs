{ fetchurl, stdenv, pkgconfig, ucommon, libosip, libexosip, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "sipwitch-1.1.2";

  src = fetchurl {
    url = "mirror://gnu/sipwitch/${name}.tar.gz";
    sha256 = "1ixbzrpndhx7i0cxx02rlnhv9948pbsbbs5gdsgp6asq42vfz3f2";
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
