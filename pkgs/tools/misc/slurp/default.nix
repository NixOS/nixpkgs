{ stdenv, fetchFromGitHub, meson, ninja, pkg-config
, cairo, libxkbcommon, wayland, wayland-protocols
, buildDocs ? true, scdoc
}:

stdenv.mkDerivation rec {
  pname = "slurp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${version}";
    sha256 = "191yjn909dax8z66ks58wjadrycpbwryirkfjcy99dhq7dijg9fh";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    cairo
    libxkbcommon
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
