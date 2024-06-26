{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "sslscan";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = "refs/tags/${version}";
    hash = "sha256-we55Oo9sIZ1FQn94xejlCKwlZBDMrQs/1f++blXTTUM=";
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
