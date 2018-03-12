{ stdenv
, fetchFromGitHub
, autoreconfHook
, findutils                     # for xargs
, gettext
, libtool
, makeWrapper
, texinfo
}:

stdenv.mkDerivation rec {
  name = "fswatch-${version}";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "05vgpd1fx9fy3vnnmq5gz236avgva82axix127xy98gaxrac52vq";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ gettext libtool makeWrapper texinfo ];

  meta = with stdenv.lib; {
    description = "A cross-platform file change monitor with multiple backends";
    homepage = https://github.com/emcrisostomo/fswatch;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
