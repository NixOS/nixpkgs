{ stdenv, fetchsvn, xlibsWrapper, libXmu, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  # The last release from 2012, 0.12, lacks '-targets'
  name = "xclip-0.12-svn-20140209";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/xclip/code/trunk";
    rev = "87";
    sha256 = "1rbcdgr73916wvzfgqjs1jhgzk8qs1yw2iiqy7ifrkjafhi37w6b";
  };

  preConfigure = "autoreconf -vfi";

  buildInputs = [ xlibsWrapper libXmu autoconf automake libtool ];

  meta = { 
    description = "Tool to access the X clipboard from a console application";
    homepage = http://sourceforge.net/projects/xclip/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
