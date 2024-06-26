{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  intltool,
  pango,
}:

stdenv.mkDerivation rec {
  pname = "paps";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "dov";
    repo = pname;
    rev = "v${version}";
    sha256 = "129wpm2ayxs6qfh2761d4x9c034ivb2bcmmcnl56qs4448qb9495";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    intltool
  ];
  buildInputs = [ pango ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Pango to PostScript converter";
    homepage = "https://github.com/dov/paps";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "paps";
  };
}
