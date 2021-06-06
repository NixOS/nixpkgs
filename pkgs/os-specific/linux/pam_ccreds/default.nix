{lib, stdenv, fetchurl, pam, openssl, db}:

stdenv.mkDerivation rec {
  name = "pam_ccreds-10";

  src = fetchurl {
    url = "https://www.padl.com/download/${name}.tar.gz";
    sha256 = "1h7zyg1b1h69civyvrj95w22dg0y7lgw3hq4gqkdcg35w1y76fhz";
  };
  patchPhase = ''
    sed 's/-o root -g root//' -i Makefile.in
  '';

  buildInputs = [ pam openssl db ];

  meta = with lib; {
    homepage = "https://www.padl.com/OSS/pam_ccreds.html";
    description = "PAM module to locally authenticate using an enterprise identity when the network is unavailable";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
