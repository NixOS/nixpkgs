{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "sl-${version}";
  version = "5.02";

  src = fetchFromGitHub {
    owner = "mtoyoda";
    repo = "sl";
    rev = version;
    sha256 = "1zrfd71zx2px2xpapg45s8xvi81xii63yl0h60q72j71zh4sif8b";
  };

  buildInputs = [ ncurses ];

  buildFlags = [ "CC=cc" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp sl $out/bin
    cp sl.1 $out/share/man/man1
  '';

  meta = {
    homepage = http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html;
    license = rec {
      shortName = "Toyoda Masashi's free software license";
      fullName = shortName;
      url = https://github.com/mtoyoda/sl/blob/master/LICENSE;
    };
    description = "Steam Locomotive runs across your terminal when you type 'sl'";
    platforms = with stdenv.lib.platforms; unix;
  };
}
