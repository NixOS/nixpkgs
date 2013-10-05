{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "byobu-5.37";

  src = fetchurl {
    url = "https://launchpad.net/byobu/trunk/5.37/+download/byobu_5.37.orig.tar.gz";
    sha256 = "e9fec9c03ebdfbeb42d08e8e7a7e45d873e1a5d5f7984a39793e37fe7cc30688";
  };

  doCheck = true;

  meta = {
    homepage = https://launchpad.net/byobu/;
    description = "Text-based window manager and terminal multiplexer";

    longDescription =
      ''Byobu is a GPLv3 open source text-based window manager and terminal multiplexer. 
        It was originally designed to provide elegant enhancements to the otherwise functional, 
        plain, practical GNU Screen, for the Ubuntu server distribution. 
        Byobu now includes an enhanced profiles, convenient keybindings, 
        configuration utilities, and toggle-able system status notifications for both 
        the GNU Screen window manager and the more modern Tmux terminal multiplexer, 
        and works on most Linux, BSD, and Mac distributions.
      '';

    license = stdenv.lib.licenses.gpl3;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.qknight ];
  };
}
