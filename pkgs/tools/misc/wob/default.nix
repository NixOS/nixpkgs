{ stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland # wayland-scanner
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "1jyia4166lp4cc8gmjmgcyz6prshhfjriam8w8mz2c5h77990fr9";
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
