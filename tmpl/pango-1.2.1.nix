id : pango-1.2.1

pkgconfig <- ./pkgconfig-0.15.0.nix
glib <- ./glib-2.2.1.nix

src = url(ftp://ftp.gtk.org/pub/gtk/v2.2/pango-1.2.1.tar.bz2)

build = ../build/pango-build.sh
