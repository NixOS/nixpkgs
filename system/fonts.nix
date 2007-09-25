{pkgs , config}:

[
  # - the user's .fonts directory
  "~/.fonts"
  # - the user's current profile
  "~/.nix-profile/lib/X11/fonts"
  "~/.nix-profile/share/fonts"
  # - the default profile
  "/nix/var/nix/profiles/default/lib/X11/fonts"
  "/nix/var/nix/profiles/default/share/fonts"
  # - a few statically built locations
  pkgs.xorg.fontbhttf
  pkgs.xorg.fontbhlucidatypewriter100dpi
  pkgs.ttf_bitstream_vera
  pkgs.corefonts
  pkgs.freefont_ttf
  pkgs.xorg.fontbh100dpi
  pkgs.xorg.fontmiscmisc
  pkgs.xorg.fontcursormisc
] ++
((config.get ["fonts" "extraFonts"]) pkgs)

