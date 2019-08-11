{ stdenv, fetchurl, ncurses, groff }:

stdenv.mkDerivation {

  name = "wiggle-1.1";

  src = fetchurl {
    url = "https://github.com/neilbrown/wiggle/archive/v1.1.tar.gz";
    sha256 = "0gg1c0zcrd5fgawvjccmdscm3fka8h1qz4v807kvy1b2y1cf9c4w";
  };

  buildInputs = [ ncurses groff ];

  configurePhase = ''
    makeFlagsArray=( CFLAGS="-I. -O3"
                     STRIP="-s"
                     INSTALL="install"
                     BINDIR="$out/bin"
                     MANDIR="$out/share/man"
                   )
    patchShebangs .
  '';

  meta = {
    homepage = http://blog.neil.brown.name/category/wiggle/;
    description = "Tool for applying patches with conflicts";

    longDescription = ''
       Wiggle applies patches to a file in a similar manner to the patch(1)
       program. The distinctive difference is, however, that wiggle will
       attempt to apply a patch even if the "before" part of the patch doesn't
       match the target file perfectly. This is achieved by breaking the file
       and patch into words and finding the best alignment of words in the file
       with words in the patch. Once this alignment has been found, any
       differences (word-wise) in the patch are applied to the file as best as
       possible. Also, wiggle will (in some cases) detect changes that have
       already been applied, and will ignore them.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };

}
