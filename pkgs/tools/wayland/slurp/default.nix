{ lib
, stdenv
, fetchFromGitHub
, cairo
, libxkbcommon
, meson
, ninja
, pkg-config
, scdoc
, wayland
, wayland-protocols
, wayland-scanner
, buildDocs ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slurp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jUuY2wuN00libHDaJEmrvQAb1o989Ly3nLyKHV0jz8Q=";
  };

  depsBuildBuild = [
    pkg-config
  ];

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

  strictDeps = true;

  mesonFlags = [ (lib.mesonEnable "man-pages" buildDocs) ];

  meta = with lib; {
    homepage = "https://github.com/emersion/slurp";
    description = "Select a region in a Wayland compositor";
    changelog = "https://github.com/emersion/slurp/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ buffet ];
    inherit (wayland.meta) platforms;
  };
})
