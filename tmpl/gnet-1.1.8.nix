pkgconfig <- ./pkgconfig-0.15.0.nix
glib <- ./glib-2.2.1.nix

src = url(http://www.gnetlibrary.org/src/gnet-1.1.8.tar.gz)

build = ../build/gnet-build.sh
