{ lib
, stdenv
, fetchFromGitLab
, glib
, meson
, ninja
, libmaxminddb
, pkg-config
, ronn
}:

stdenv.mkDerivation rec {
  pname = "ipcalc";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "ipcalc";
    repo = "ipcalc";
    rev = version;
    sha256 = "0qg516jv94dlk0qj0bj5y1dd0i31ziqcjd6m00w8xp5wl97bj2ji";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    libmaxminddb
    ronn
  ];

  meta = with lib; {
    description = "Simple IP network calculator";
    homepage = "https://gitlab.com/ipcalc/ipcalc";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
