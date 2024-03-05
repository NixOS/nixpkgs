{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.3.1";
  pname = "snore";

  src = fetchFromGitHub {
    owner = "clamiax";
    repo = pname;
    rev = version;
    hash = "sha256-bKPGSePzp4XEZFY0QQr37fm3R1v3hLD6FeySFd7zNJc=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "sleep with feedback";
    homepage = "https://github.com/clamiax/snore";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
    mainProgram = "snore";
  };
}
