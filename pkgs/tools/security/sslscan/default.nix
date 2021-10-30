{ lib
, stdenv
, fetchFromGitHub
, openssl
}:

stdenv.mkDerivation rec {
  pname = "sslscan";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = version;
    sha256 = "sha256-L6cNmvR6zy2tkMHh+LBsQ3VZDUr0tD5AlOEj+dTLV5k=";
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
