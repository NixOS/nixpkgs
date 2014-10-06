{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, ncurses, confuse
, libnl }:

stdenv.mkDerivation rec {
  name = "bmon-${version}";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "tgraf";
    repo = "bmon";
    rev = "v${version}";
    sha256 = "0k6cwprwnrnilbs2fgkx7z9mg6rr11wf6djq6pjfc7fjn2fjvybi";
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
