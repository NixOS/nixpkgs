{ lib, stdenv, fetchurl, pkg-config, libfido2, pam, openssl }:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "1.1.1";

  src     = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${pname}-${version}.tar.gz";
    sha256 = "12p3pkrp32vzpg7707cgx8zgvgj8iqwhy39sm761k7plqi027mmp";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libfido2 pam openssl ];

  preConfigure = ''
    configureFlagsArray+=("--with-pam-dir=$out/lib/security")
  '';

  # a no-op makefile to prevent building the fuzz targets
  postConfigure = ''
    cat > fuzz/Makefile <<EOF
    all:
    install:
    EOF
  '';

  meta = with lib; {
    homepage = "https://developers.yubico.com/pam-u2f/";
    description = "A PAM module for allowing authentication with a U2F device";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
  };
}
