{ stdenv, fetchurl, pkgconfig, libu2f-host, libu2f-server, pam }:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "1.0.8";

  src     = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${pname}-${version}.tar.gz";
    sha256 = "16awjzx348imjz141fzzldy00qpdmw2g37rnq430w5mnzak078jj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libu2f-host libu2f-server pam ];

  # Fix the broken include in 1.0.1
  CFLAGS = "-I${libu2f-host}/include/u2f-host";

  preConfigure = ''
    configureFlagsArray+=("--with-pam-dir=$out/lib/security")
  '';

  meta = with stdenv.lib; {
    homepage = "https://developers.yubico.com/pam-u2f/";
    description = "A PAM module for allowing authentication with a U2F device";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
  };
}
