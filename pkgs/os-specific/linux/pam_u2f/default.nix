{ stdenv, fetchurl, pkgconfig, libfido2, pam, openssl }:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "1.1.0";

  src     = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${pname}-${version}.tar.gz";
    sha256 = "01fwbrfnjkv93vvqm54jywdcxa1p7d4r32azicwnx75nxfbbzhqd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libfido2 pam openssl ];

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
