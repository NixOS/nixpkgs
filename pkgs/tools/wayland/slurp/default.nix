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
    changelog = "https://github.com/emersion/slurp/releases/tag/v${finalAttrs.version}";
    description = "Select a region in a Wayland compositor";
    inherit (wayland.meta) platforms;
    homepage = "https://github.com/emersion/slurp";
    license = licenses.mit;
    mainProgram = "slurp";
    maintainers = with maintainers; [ buffet ];
  };
})
