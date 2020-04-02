{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, scdoc, wayland }:

stdenv.mkDerivation rec {
  pname = "kanshi";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "kanshi";
    rev = "v${version}";
    sha256 = "0nbpgm8qnn7ljsg9vgs35kl8l4rrk542vdcbx8wrn9r909ld3x92";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];
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
