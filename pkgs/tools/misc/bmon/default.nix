{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, ncurses, confuse
, libnl }:

stdenv.mkDerivation rec {
  name = "bmon-${version}";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "tgraf";
    repo = "bmon";
    rev = "v${version}";
    sha256 = "0rh0r8gabcsqq3d659yqk8nz6y4smsi7p1vwa2v584m2l2d0rqd6";
  };

  buildInputs = [ autoconf automake pkgconfig ncurses confuse libnl ];

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
