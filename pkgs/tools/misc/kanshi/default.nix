{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc, wayland }:

stdenv.mkDerivation rec {
  pname = "kanshi";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "kanshi";
    rev = "v${version}";
    sha256 = "0v50q1s105c2rar6mi1pijm8llsnsp62gv4swd3ddjn5rwallg46";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland ];

  meta = with stdenv.lib; {
    description = "Dynamic display configuration tool";
    longDescription = ''
      kanshi allows you to define output profiles that are automatically enabled
      and disabled on hotplug. For instance, this can be used to turn a laptop's
      internal screen off when docked.

      kanshi can be used on Wayland compositors supporting the
      wlr-output-management protocol.
    '';
    homepage = "https://github.com/emersion/kanshi";
    downloadPage = "https://github.com/emersion/kanshi";
    license = licenses.mit;
    maintainers = with maintainers; [ balsoft ];
    platforms = platforms.linux;
  };
}
