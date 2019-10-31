{ stdenv
, fetchFromGitHub
, autoreconfHook
                     # for xargs
, gettext
, libtool
, makeWrapper
, texinfo
, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "fswatch";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "1d1fvm36qgh6a5j9v24wai61d297pvzxr14jngjlhh4i474ff21i";
  };

  nativeBuildInputs = [ autoreconfHook ] ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];
  buildInputs = [ gettext libtool makeWrapper texinfo ];

  meta = with stdenv.lib; {
    description = "A cross-platform file change monitor with multiple backends";
    homepage = https://github.com/emcrisostomo/fswatch;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
