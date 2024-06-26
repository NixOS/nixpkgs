{ lib, stdenv, fetchurl, pkg-config, libfido2, pam, openssl }:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "1.3.0";

  src     = fetchurl {
    url = "https://developers.yubico.com/pam-u2f/Releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-cjYMaHVIXrTfQJ2o+PUrF4k/BeTZmFKcI4gUSA4RUiA=";
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
    description = "PAM module for allowing authentication with a U2F device";
    changelog = "https://github.com/Yubico/pam-u2f/raw/pam_u2f-${version}/NEWS";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
    mainProgram = "pamu2fcfg";
  };
}
