pkgconfig <- ./pkgconfig-0.15.0.nix
glib <- ./glib-2.2.1.nix
atk <- ./atk-1.2.0.nix
pango <- ./pango-1.2.1.nix

src = ../dist/gtk+-2.2.1.tar.bz2

build = ../dist/gtk+-build.sh
