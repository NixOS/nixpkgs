{ stdenv, fetchurl, autoreconfHook
, bison, flac, flex, id3v2, vorbis-tools
}:

stdenv.mkDerivation rec {
  name = "cuetools-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/svend/cuetools/archive/${version}.tar.gz";
    sha256 = "01xi3rvdmil9nawsha04iagjylqr1l9v9vlzk99scs8c207l58i4";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ bison flac flex id3v2 vorbis-tools ];

  meta = with stdenv.lib; {
    description = "A set of utilities for working with cue files and toc files";
    homepage = https://github.com/svend/cuetools;
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel jcumming ];
    platforms = platforms.all;
  };
}
