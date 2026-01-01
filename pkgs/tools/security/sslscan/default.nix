{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "sslscan";
<<<<<<< HEAD
  version = "2.2.1";
=======
  version = "2.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-HE0Jc0FSH/hK7wDhEOFR6nJJzyVAVlNhrCVlY0AlNU4=";
=======
    hash = "sha256-i8nrGni7mClJQIlkDt20JXyhlJALKCR0MZk51ACtev0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [ openssl ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Tests SSL/TLS services and discover supported cipher suites";
    mainProgram = "sslscan";
    homepage = "https://github.com/rbsec/sslscan";
    changelog = "https://github.com/rbsec/sslscan/blob/${version}/Changelog";
<<<<<<< HEAD
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fpletz
=======
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      fpletz
      globin
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
}
