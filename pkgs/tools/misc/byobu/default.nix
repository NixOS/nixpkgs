{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "byobu-5.87";

  src = fetchurl {
    url = "https://launchpad.net/byobu/trunk/5.87/+download/byobu_5.87.orig.tar.gz";
    sha256 = "08v9y5hxb92caf5zp83fiq0jfwi167vw1ylf42s65x1ng8rvryqh";
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
