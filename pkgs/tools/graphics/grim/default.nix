{ lib
, stdenv
, fetchFromSourcehut
, fetchpatch
, pixman
, libpng
, libjpeg
, meson
, ninja
, pkg-config
, scdoc
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "grim";
  version = "1.4.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lwJn1Lysv1qLauqmrduUlzdoKUrUM5uBjv+dWSsrM6w=";
  };

  mesonFlags = [
    "-Dwerror=false"
  ];

  patches = [
    # Fixes build on 32bit platforms. Patch is upstream, but unreleased
    (fetchpatch {
      name = "grim-fix-32bit-printf.patch";
      url = "https://git.sr.ht/~emersion/grim/commit/89e02e663fabc534b7e7039514f60a8c5d70070d.patch";
      sha256 = "1gwb060v3q856p84y0mqqpkqmgb9jwn70y4mzv35y4b9xld8inci";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    pixman
    libpng
    libjpeg
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "Grab images from a Wayland compositor";
    homepage = "https://github.com/emersion/grim";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
