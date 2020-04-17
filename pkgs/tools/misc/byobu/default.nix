{ stdenv, fetchurl, python3, perl, textual-window-manager }:

stdenv.mkDerivation rec {
  version = "5.133";
  name = "byobu-" + version;

  src = fetchurl {
    url = "https://launchpad.net/byobu/trunk/${version}/+download/byobu_${version}.orig.tar.gz";
    sha256 = "0qvmmdnvwqbgbhn5c8asmrmjhclcl029py2d2zvmd7h5ij7s93jd";
  };

  doCheck = true;

  buildInputs = [ python3 perl ];
  propagatedBuildInputs = [ textual-window-manager ];

  meta = {
    homepage = "https://launchpad.net/byobu/";
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
