id : pan-0.13.91

pkgconfig <- ./pkgconfig-0.15.0.nix
glib <- ./glib-2.2.1.nix
atk <- ./atk-1.2.0.nix
pango <- ./pango-1.2.1.nix
gtk <- ./gtk+-2.2.1.nix
gnet <- ./gnet-1.1.8.nix
pspell <- ./pspell-.12.2.nix
gtkspell <- ./gtkspell-2.0.2.nix

src = url(http://pan.rebelbase.com/download/releases/0.13.91/SOURCE/pan-0.13.91.tar.bz2)

build = ../build/pan-build-2.sh
