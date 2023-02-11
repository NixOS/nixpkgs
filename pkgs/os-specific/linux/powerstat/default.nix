{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.03.00";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-eiFzWKY4LrudfjMKDk4clmvCqYOGvWFokn6jEryMYBo=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Laptop power measuring tool";
    homepage = "https://github.com/ColinIanKing/powerstat";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
