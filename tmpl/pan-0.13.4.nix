pkgconfig <- ./pkgconfig-0.15.0.nix
glib <- ./glib-2.2.1.nix
atk <- ./atk-1.2.0.nix
pango <- ./pango-1.2.1.nix
gtk <- ./gtk+-2.2.1.nix
gnet <- ./gnet-1.1.8.nix

src = ../dist/pan-0.13.4.tar.bz2

build = ../dist/pan-build.sh
