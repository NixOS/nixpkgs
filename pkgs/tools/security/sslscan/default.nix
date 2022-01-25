{ lib
, stdenv
, fetchFromGitHub
, openssl
}:

stdenv.mkDerivation rec {
  pname = "sslscan";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = version;
    sha256 = "sha256-ROdi1pU2VeswmItHOSZimOkPYlgdqEMg2b7zt0f9WrM=";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = "https://github.com/rbsec/sslscan";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
