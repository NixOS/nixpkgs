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
, buildDocs ? true, scdoc
}:

stdenv.mkDerivation rec {
  pname = "slurp";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${version}";
    sha256 = "1fby2v2ylcadgclds05wpkl9xi2r9dfz49dqyqpn20rjv1wnz3jv";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
