{ lib, stdenv, fetchFromGitHub
, meson, pkg-config, wayland-scanner, ninja
, wayland, wayland-protocols, freetype,
}:

stdenv.mkDerivation rec {
  pname = "sov";
  version = "0.72";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = pname;
    rev = version;
    sha256 = "sha256-av+st0tux+ho8bfJwx6Nk1pma1Pjvv/dpW5BWnUDNvQ=";
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
