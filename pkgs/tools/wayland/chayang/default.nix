{ lib
, stdenv
, fetchFromSourcehut
, meson
, ninja
, pkg-config
, wayland-scanner
, wayland-protocols
, wayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chayang";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "chayang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3Vu9/Bu2WQe2Yx/2BK25pEpuPNwX6g3qoFUMznCFHeI=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland-protocols
    wayland
  ];

  meta = with lib; {
    description = "Gradually dim the screen on Wayland";
    homepage = "https://git.sr.ht/~emersion/chayang/";
    license = licenses.mit;
    longDescription = ''
      Gradually dim the screen on Wayland.
      Can be used to implement a grace period before locking the session.
    '';
    maintainers = with maintainers; [ mxkrsv ];
    platforms = platforms.linux;
    mainProgram = "chayang";
  };
})
