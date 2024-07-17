{
  lib,
  stdenv,
  fetchurl,
  pam,
  openssl,
  db,
}:

stdenv.mkDerivation rec {
  pname = "pam_ccreds";
  version = "10";

  src = fetchurl {
    url = "https://www.padl.com/download/pam_ccreds-${version}.tar.gz";
    sha256 = "1h7zyg1b1h69civyvrj95w22dg0y7lgw3hq4gqkdcg35w1y76fhz";
  };
  patchPhase = ''
    sed 's/-o root -g root//' -i Makefile.in
  '';

  buildInputs = [
    pam
    openssl
    db
  ];

  meta = with lib; {
    homepage = "https://www.padl.com/OSS/pam_ccreds.html";
    description = "PAM module to locally authenticate using an enterprise identity when the network is unavailable";
    mainProgram = "ccreds_chkpwd";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
