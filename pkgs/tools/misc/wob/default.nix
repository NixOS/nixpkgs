{ stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland # wayland-scanner
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "1z0vwss3ix5mf7mqpm4dzlv1bblddfi47ykblj0nmscxn1sinr7j";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland ];
  buildInputs = [ wayland-protocols ];

  meta = with stdenv.lib; {
    description = "A lightweight overlay bar for Wayland";
    longDescription = ''
      A lightweight overlay volume/backlight/progress/anything bar for Wayland,
      inspired by xob.
    '';
    inherit (src.meta) homepage;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
