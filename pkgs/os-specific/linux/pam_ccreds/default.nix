{stdenv, fetchurl, pam, openssl, db}:

stdenv.mkDerivation {
  name = "pam_ccreds-10";

  src = fetchurl {
    url = "http://www.padl.com/download/pam_ccreds.tgz";
    sha256 = "1h7zyg1b1h69civyvrj95w22dg0y7lgw3hq4gqkdcg35w1y76fhz";
  };
  patchPhase = ''
    sed 's/-o root -g root//' -i Makefile.in
  '';

  buildInputs = [pam openssl db];
  meta = {
    homepage = "http://www.padl.com/OSS/pam_ccreds.html";
    description = "PAM module to locally authenticate using an enterprise identity when the network is unavailable";
    platforms = stdenv.lib.platforms.linux;
  };
}
