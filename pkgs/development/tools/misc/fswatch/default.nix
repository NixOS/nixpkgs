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
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "1w83bpgx0wsgn70jyxwrvh9dsivrq41ifcignjzdxdwz9j0rwhh1";
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
