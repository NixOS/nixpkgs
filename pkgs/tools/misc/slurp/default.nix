{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, cairo, wayland, wayland-protocols
, buildDocs ? true, scdoc
}:

stdenv.mkDerivation rec {
  pname = "slurp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${version}";
    sha256 = "15fqspg3cjl830l95ibibprxf9p13mc2rpyf9bdwsdx2f4qrkq62";
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
    homepage = https://github.com/emersion/slurp;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
