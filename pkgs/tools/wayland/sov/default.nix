{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, freetype
, wayland
, wayland-protocols
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sov";
  version = "0.73";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = "sov";
    rev = finalAttrs.version;
    sha256 = "sha256-cjbTSvW1fCPl2wZ848XrUPU0bDQ4oXy+D8GqyBMaTwQ=";
  };

  postPatch = ''
    substituteInPlace src/sov/main.c --replace '/usr' $out
  '';

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    freetype
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "An overlay that shows schemas for all workspaces to make navigation in sway easier.";
    homepage = "https://github.com/milgra/sov";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
})
