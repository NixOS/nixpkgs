{ stdenv
, fetchFromGitHub
, autoreconfHook
                     # for xargs
, gettext
, libtool
, makeWrapper
, texinfo
}:

stdenv.mkDerivation rec {
  name = "fswatch-${version}";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "16f3g6s79gs1sp2ra3cka4c5mf5b557cx697bwcdfgj6r19ni5j7";
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
