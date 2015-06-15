{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, ncurses, confuse
, libnl }:

stdenv.mkDerivation rec {
  name = "bmon-${version}";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "tgraf";
    repo = "bmon";
    rev = "v${version}";
    sha256 = "16qwazays2j448kmfckv6wvh4rhmhc9q4vp1s75hm9z02cmhvk8q";
  };

  # https://github.com/tgraf/bmon/pull/24#issuecomment-98068887
  postPatch = "sed '1i#include <net/if.h>' -i src/in_netlink.c";

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
