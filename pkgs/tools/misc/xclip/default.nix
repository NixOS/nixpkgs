{ stdenv, fetchsvn, xlibsWrapper, libXmu, autoreconfHook }:

stdenv.mkDerivation rec {
  # The last release from 2012, 0.12, lacks '-targets'
  name = "xclip-0.12-svn-20140209";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/xclip/code/trunk";
    sha256 = "0d6r38xas5l79l700sdm14l41vvjqhah613367ha8kcvx54zkddz";
  };

  buildInputs = [ xlibsWrapper libXmu autoreconfHook ];

  meta = {
    description = "Tool to access the X clipboard from a console application";
    homepage = http://sourceforge.net/projects/xclip/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
