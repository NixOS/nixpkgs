{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.02.27";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-P6DhsHnB+ak35JpUfD8Q8XbgMhI1QKKe31B8uMT2ZcY=";
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
