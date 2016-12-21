{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, ncurses, confuse
, libnl }:

stdenv.mkDerivation rec {
  name = "bmon-${version}";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "tgraf";
    repo = "bmon";
    rev = "v${version}";
    sha256 = "1a4sj8pf02392zghr9wa1dc8x38fj093d4hg1fcakzrdjvrg1p2h";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig ];

  buildInputs = [ ncurses confuse libnl ];

  preConfigure = "sh ./autogen.sh";

  meta = with stdenv.lib; {
    description = "Network bandwidth monitor";
    homepage = https://github.com/tgraf/bmon;
    # Licensed unter BSD and MIT
    #  - https://github.com/tgraf/bmon/blob/master/LICENSE.BSD
    #  - https://github.com/tgraf/bmon/blob/master/LICENSE.MIT
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor pSub ];
  };
}
