{ lib, stdenv, fetchurl, pkg-config, libfido2, pam, openssl }:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "1.2.0";

  src     = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-IwPm+Zsf3o7jw6sopN4tpt3SJclTaT6EXWstg4giH7M=";
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
    mainProgram = "pamu2fcfg";
  };
}
