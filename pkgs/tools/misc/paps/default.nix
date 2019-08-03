{ stdenv, fetchFromGitHub
, autoconf, automake, pkgconfig, pango }:

stdenv.mkDerivation rec {
  pname = "paps";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "dov";
    repo = pname;
    rev = version;
    sha256 = "1f0qcawak76zk2xypipb6sy4bd8mixlrjby851x216a7f6z8fd4y";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig ];
  buildInputs = [ pango ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "Pango to PostScript converter";
    homepage = https://github.com/dov/paps;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
