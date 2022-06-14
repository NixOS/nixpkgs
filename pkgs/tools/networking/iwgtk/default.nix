{ fetchFromGitHub, gtk4, lib, pkg-config, stdenv }:

stdenv.mkDerivation rec {
  pname = "iwgtk";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "j-lentz";
    repo = pname;
    rev = "v${version}";
    sha256 = "pIN8ry9b2pt8wegeQt4sKPAdkYiw9/Am0sSuBY1+OVs=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk4 ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=''" ];

  meta = with lib; {
    description = "Lightweight, graphical wifi management utility for Linux";
    homepage = "https://github.com/j-lentz/iwgtk";
    changelog = "https://github.com/j-lentz/iwgtk/blob/v${version}/CHANGELOG";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda ];
  };
}
