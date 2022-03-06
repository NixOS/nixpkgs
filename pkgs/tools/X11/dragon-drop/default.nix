{ lib, stdenv, gtk, pkg-config, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dragon-drop";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mwh";
    repo = "dragon";
    rev = "v${version}";
    sha256 = "sha256-wqG6idlVvdN+sPwYgWu3UL0la5ssvymZibiak3KeV7M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk ];

  installPhase = ''
    install -D dragon -t $out/bin
  '';

  meta = with lib; {
    description = "Simple drag-and-drop source/sink for X";
    homepage = "https://github.com/mwh/dragon";
    maintainers = with maintainers; [ jb55 markus1189 ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
