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
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "emcrisostomo";
    repo = "fswatch";
    rev = version;
    sha256 = "1g329aapdvbzhr39wyh295shpfq5f0nlzsqkjnr8l6zzak7f4yrg";
  };

  buildInputs = [ autoreconfHook gettext libtool makeWrapper texinfo ];

  meta = with stdenv.lib; {
    description = "A cross-platform file change monitor with multiple backends";
    homepage = https://github.com/emcrisostomo/fswatch;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
