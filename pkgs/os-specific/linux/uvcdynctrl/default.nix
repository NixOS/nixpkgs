{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation {
  version = "0.3.0";
  pname = "uvcdynctrl";

  src = fetchFromGitHub {
    owner = "cshorler";
    repo = "webcam-tools";
    rev = "bee2ef3c9e350fd859f08cd0e6745871e5f55cb9";
    sha256 = "0s15xxgdx8lnka7vi8llbf6b0j4rhbjl6yp0qxaihysf890xj73s";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ libxml2 ];

  prePatch = ''
    local fixup_list=(
      uvcdynctrl/CMakeLists.txt
      uvcdynctrl/udev/rules/80-uvcdynctrl.rules
      uvcdynctrl/udev/scripts/uvcdynctrl
    )
    for f in "''${fixup_list[@]}"; do
      substituteInPlace "$f" \
        --replace "/etc/udev" "$out/etc/udev" \
        --replace "/lib/udev" "$out/lib/udev"
    done
  '';

  meta = with lib; {
    description = "A simple interface for devices supported by the linux UVC driver";
    homepage = "https://guvcview.sourceforge.net";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.puffnfresh ];
    platforms = platforms.linux;
  };
}
