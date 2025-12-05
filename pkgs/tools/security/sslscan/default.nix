{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "sslscan";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    tag = version;
    hash = "sha256-HE0Jc0FSH/hK7wDhEOFR6nJJzyVAVlNhrCVlY0AlNU4=";
  };

  buildInputs = [ openssl ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = with lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    mainProgram = "sslscan";
    homepage = "https://github.com/rbsec/sslscan";
    changelog = "https://github.com/rbsec/sslscan/blob/${version}/Changelog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      fpletz
      globin
    ];
  };
}
