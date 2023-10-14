{ lib
, stdenv
, fetchFromGitHub
, openssl
}:

stdenv.mkDerivation rec {
  pname = "sslscan";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = "refs/tags/${version}";
    hash = "sha256-AsOuNJ5adI7/8A6siK4MzLtpBstsU7JxX1d6WWVJHAY=";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = "https://github.com/rbsec/sslscan";
    changelog = "https://github.com/rbsec/sslscan/blob/${version}/Changelog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
