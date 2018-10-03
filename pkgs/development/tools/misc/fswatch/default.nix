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
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "18nrp2l1rzrhnw4p6d9r6jaxkkvxkiahvahgws2j00q623v0f3ij";
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
