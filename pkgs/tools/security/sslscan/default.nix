{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "sslscan";
  version = "1.11.13";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = "${version}-rbsec";
    sha256 = "0sa8iw91wi3515lw761j84wagab1x9rxr0mn8m08qj300z2044yk";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "PREFIX=$(out)" "CC=cc" ];

  meta = with stdenv.lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = https://github.com/rbsec/sslscan;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fpletz globin ];
    platforms = platforms.all;
  };
}
