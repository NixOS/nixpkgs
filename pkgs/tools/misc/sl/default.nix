{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "sl-${version}";
  version = "5.04";

  src = fetchFromGitHub {
    owner = "eyJhb";
    repo = "sl";
    rev = "${version}";
    sha256 = "029lv6vw39c7gj8bkfyqs8q4g32174vbmghhhgfk8wrhnxq60qn7";
  };

  buildInputs = [ ncurses ];

  buildFlags = [ "CC=cc" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp sl $out/bin
    cp sl.1 $outputMan
  '';

  meta = with stdenv.lib; {
    homepage = http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html;
    license = rec {
      shortName = "Toyoda Masashi's free software license";
      fullName = shortName;
      url = https://github.com/eyJhb/sl/blob/master/LICENSE;
    };
    maintainers = [ maintainers.eyjhb ];
    description = "Steam Locomotive runs across your terminal when you type 'sl'";
    platforms = platforms.unix;
  };
}
