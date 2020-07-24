{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "genext2fs-1.4.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/genext2fs/genext2fs-1.4.1.tar.gz";
    sha256 = "1z7czvsf3ircvz2cw1cf53yifsq29ljxmj15hbgc79l6gbxbnka0";
  };

  # https://sourceforge.net/p/genext2fs/bugs/2/
  # Will be fixed in the next release, whenever this happens
  postPatch = ''
    sed -e 's@4 [*] (EXT2_TIND_BLOCK+1)@-1+&@' -i genext2fs.c
  '';

  meta = with stdenv.lib; {
    homepage = "http://genext2fs.sourceforge.net/";
    description = "A tool to generate ext2 filesystem images without requiring root privileges";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
