{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.03.03";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-D8VwczXHUHQ8p03IgYW3t8hOIGHKp0n1c7FpAUWua74=";
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
