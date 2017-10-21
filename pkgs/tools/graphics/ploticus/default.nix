{stdenv, fetchurl, zlib, libX11, libpng}:

stdenv.mkDerivation {
  name = "ploticus-2.42";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/ploticus/ploticus/2.41/pl241src.tar.gz;
    sha256 = "1065r0nizjixi9sxxfxrnwg10r458i6fgsd23nrxa200rypvdk7c";
  };

  buildInputs = [ zlib libX11 libpng ];

  hardeningDisable = [ "format" ];

  patches = [ ./ploticus-install.patch ];

  # Make the symlink relative instead of absolute.
  # Otherwise it breaks when auto-moved to $out/share.
  preFixup = ''
    ln -sf pl.1 "$out"/man/man1/ploticus.1
  '';

  meta = with stdenv.lib; {
    description = "A non-interactive software package for producing plots and charts";
    longDescription = ''Ploticus is a free, GPL'd, non-interactive
      software package for producing plots, charts, and graphics from
      data.  Ploticus is good for automated or just-in-time graph
      generation, handles date and time data nicely, and has basic
      statistical capabilities.  It allows significant user control
      over colors, styles, options and details.'';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    homepage = http://ploticus.sourceforge.net/;
    platforms = with platforms; linux;
  };
}
