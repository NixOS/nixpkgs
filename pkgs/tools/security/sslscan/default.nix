{ lib
, stdenv
, fetchFromGitHub
, openssl
}:

stdenv.mkDerivation rec {
  pname = "sslscan";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = version;
    sha256 = "sha256-1j5p9cuSxc8u6/+puP9ywHEljeva18m+WO3M8gbpkIU=";
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
