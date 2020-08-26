{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, cairo, wayland, wayland-protocols
, buildDocs ? true, scdoc
}:

stdenv.mkDerivation rec {
  pname = "slurp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${version}";
    sha256 = "0580m6kaiilgsrcj608r837r37sl6a25y7w21p7d6ij20fs3gvg1";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    cairo
    wayland
    wayland-protocols
  ];

  mesonFlags = stdenv.lib.optional buildDocs "-Dman-pages=enabled";

  meta = with stdenv.lib; {
    description = "Select a region in a Wayland compositor";
    homepage = "https://github.com/emersion/slurp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
