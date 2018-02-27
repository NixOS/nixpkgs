{ stdenv, autoconf, automake, fetchFromGitHub, ncurses, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "htop-vim";

  src = fetchFromGitHub {
    owner = "KoffeinFlummi";
    repo = "htop-vim";
    sha256 = "03mxh4zl1c6hf1sqvcmlzf48vzgp5nglfb80c38b99g9dqiphqyf";
    rev = "70c91d6d598f15b0311ae6779810e036133e72d2";
  };

  buildPhase = ''
    ./autogen.sh && ./configure --prefix=$out --program-suffix=-vim && make
    '';

  buildInputs = [ autoconf automake ncurses pkgconfig ];

  installPhase = ''
    make install 
  '';

  meta = {
    homepage = https://github.com/KoffeinFlummi/htop-vim;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.linux;
  };
}
