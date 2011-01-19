{ fetchurl, stdenv, pkgconfig, ucommon, libosip, libexosip, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "sipwitch-0.9.2";

  src = fetchurl {
    url = "mirror://gnu/sipwitch/${name}.tar.gz";
    sha256 = "1xww6v4s45ss7v4548gxk6dgal5605cxnvdfsblmqn3ydzp6227h";
  };

  buildInputs = [ pkgconfig ucommon libosip libexosip openssl zlib ];

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
