{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation {
  pname = "hackertyper";
  version = "2.1";

  src = fetchFromGitHub {
    owner  = "Hurricane996";
    repo   = "Hackertyper";
    rev    = "8d08e3200c65817bd8c5bd0baa5032919315853b";
    sha256 = "0shri0srihw9fk027k61qkxr9ikwkn28aaamrhps6lg0vpbqpx2w";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ ncurses ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/hackertyper -v
  '';

  meta = with lib; {
    description = "A C rewrite of hackertyper.net";
    homepage = "https://github.com/Hurricane996/Hackertyper";
    license = licenses.gpl3;
    maintainers = [ maintainers.marius851000 ];
    mainProgram = "hackertyper";
  };
}
