{ lib, stdenv, fetchFromGitHub, libX11, libXdamage, libXrender, libXcomposite, libXext, installShellFiles, git }:

stdenv.mkDerivation rec {
  pname = "find-cursor";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "find-cursor";
    rev = "v${version}";
    sha256 = "sha256-/Dw4bOTCnpCbeI0YJ5DJ9Q2AGBognylUk7xYGn0KIA8=";
  };

  nativeBuildInputs = [ installShellFiles git ];
  buildInputs = [ libX11 libXdamage libXrender libXcomposite libXext ];
  preInstall = "mkdir -p $out/share/man/man1";
  installFlags = "PREFIX=${placeholder "out"}";

  meta = with lib; {
    description = "Simple XLib program to highlight the cursor position";
    homepage = "https://github.com/arp242/find-cursor";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.yanganto ];
  };
}
