{ buildFHSUserEnv, callPackage, lib, stdenvNoCC }:
let

  shticker-book-unwritten-unwrapped = callPackage ./unwrapped.nix { };

in buildFHSUserEnv {
  name = "shticker_book_unwritten";
  targetPkgs = pkgs: with pkgs; [
      alsaLib
      xorg.libX11
      xorg.libXext
      libglvnd
      shticker-book-unwritten-unwrapped
  ];
  runScript = "shticker_book_unwritten";

  meta = with lib; {
    description = "Minimal CLI launcher for the Toontown Rewritten MMORPG";
    homepage = "https://github.com/JonathanHelianthicusDoe/shticker_book_unwritten";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.reedrw ];
    platforms = platforms.linux;
  };
}
