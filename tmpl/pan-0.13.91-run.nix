id : pan-0.13.91-run

pan <- ./pan-0.13.91.nix

glib <- ./glib-2.2.1.nix
atk <- ./atk-1.2.0.nix
pango <- ./pango-1.2.1.nix
gtk <- ./gtk+-2.2.1.nix
gnet <- ./gnet-1.1.8.nix
pspell <- ./pspell-.12.2.nix
gtkspell <- ./gtkspell-2.0.2.nix

run = ../build/pan-run.sh
