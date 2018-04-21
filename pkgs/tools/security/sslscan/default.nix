{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  name = "sslscan-${version}";
  version = "1.11.11";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = "${version}-rbsec";
    sha256 = "0k1agdz52pdgihwfwbygp0mlwkf757vcwhvwc0mrz606l2wbmwmr";
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
