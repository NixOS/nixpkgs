id : gtkspell-2.0.2

pkgconfig <- ./pkgconfig-0.15.0.nix
glib <- ./glib-2.2.1.nix
atk <- ./atk-1.2.0.nix
pango <- ./pango-1.2.1.nix
gtk <- ./gtk+-2.2.1.nix
pspell <- ./pspell-.12.2.nix

src = url(http://pan.rebelbase.com/download/extras/gtkspell/SOURCES/gtkspell-2.0.2.tar.gz)

build = ../build/gtkspell-build.sh
