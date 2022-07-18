{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, wayland
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "kanshi";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "kanshi";
    rev = "v${version}";
    sha256 = "sha256-RVMeS2qEjTYK6r7IwMeFSqfRpKR8di2eQXhewfhTnYI=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland ];

  meta = with lib; {
    homepage = "https://github.com/emersion/kanshi";
    description = "Dynamic display configuration tool";
    longDescription = ''
      kanshi allows you to define output profiles that are automatically enabled
      and disabled on hotplug. For instance, this can be used to turn a laptop's
      internal screen off when docked.

      kanshi can be used on Wayland compositors supporting the
      wlr-output-management protocol.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ balsoft ];
    platforms = platforms.linux;
  };
}
