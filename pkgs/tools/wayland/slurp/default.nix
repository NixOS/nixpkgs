{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, cairo
, libxkbcommon
, wayland
, wayland-protocols
, wayland-scanner
, buildDocs ? true, scdoc
}:

stdenv.mkDerivation rec {
  pname = "slurp";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${version}";
    sha256 = "sha256-5ZB34rqLyZmfjT/clxNRDmF0qgITFZ5xt/gIEXQzvQE=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ] ++ lib.optional buildDocs scdoc;

  buildInputs = [
    cairo
    libxkbcommon
    wayland
    wayland-protocols
  ];

  mesonFlags = lib.optional buildDocs "-Dman-pages=enabled";

  meta = with lib; {
    description = "Select a region in a Wayland compositor";
    homepage = "https://github.com/emersion/slurp";
    license = licenses.mit;
    maintainers = with maintainers; [ buffet ];
    platforms = platforms.linux;
  };
}
