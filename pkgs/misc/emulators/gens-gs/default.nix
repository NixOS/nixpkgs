{ stdenv, fetchurl, pkgconfig, gtk2, SDL, nasm, zlib, libpng, libGLU_combined }:

stdenv.mkDerivation {
  name = "gens-gs-7";

  src = fetchurl {
    url = http://retrocdn.net/images/6/6d/Gens-gs-r7.tar.gz;
    sha256 = "1ha5s6d3y7s9aq9f4zmn9p88109c3mrj36z2w68jhiw5xrxws833";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 SDL nasm zlib libpng libGLU_combined ];

  # Work around build failures on recent GTK+.
  # See http://ubuntuforums.org/showthread.php?p=10535837
  NIX_CFLAGS_COMPILE = "-UGTK_DISABLE_DEPRECATED -UGSEAL_ENABLE";

  meta = with stdenv.lib; {
    homepage = https://segaretro.org/Gens/GS;
    description = "A Genesis/Mega Drive emulator";
    platforms = [ "i686-linux" ];
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.eelco ];
  };
}
