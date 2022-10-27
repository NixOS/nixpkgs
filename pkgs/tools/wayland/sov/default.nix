{ lib, stdenv, fetchFromGitHub
, meson, pkg-config, wayland-scanner, ninja
, wayland, wayland-protocols, freetype,
}:

stdenv.mkDerivation rec {
  pname = "sov";
  version = "0.73";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = pname;
    rev = version;
    sha256 = "sha256-cjbTSvW1fCPl2wZ848XrUPU0bDQ4oXy+D8GqyBMaTwQ=";
  };

  postPatch = ''
    substituteInPlace src/sov/main.c --replace '/usr' $out
  '';
  nativeBuildInputs = [ meson pkg-config wayland-scanner ninja ];
  buildInputs = [ wayland wayland-protocols freetype ];

  meta = with lib; {
    description = "An overlay that shows schemas for all workspaces to make navigation in sway easier.";
    homepage = "https://github.com/milgra/sov";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ travisdavis-ops ];
  };
}
