{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
, wlr-protocols
, libGL
}:

stdenv.mkDerivation rec {
  pname = "wl-mirror";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "wl-mirror";
    rev = "v${version}";
    sha256 = "1wjdjzj6h1q51yg70gdrq2yrgg6ihamcwhizxfrjq8955yy2y6ly";
  };

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace 'WL_PROTOCOL_DIR "/usr' 'WL_PROTOCOL_DIR "${wayland-protocols}' \
      --replace 'WLR_PROTOCOL_DIR "/usr' 'WLR_PROTOCOL_DIR "${wlr-protocols}'
  '';

  nativeBuildInputs = [ cmake pkg-config wayland-scanner ];
  buildInputs = [
    libGL
    wayland
    wayland-protocols
    wlr-protocols
  ];

  meta = with lib; {
    homepage = "https://github.com/Ferdi265/wl-mirror";
    description = "Mirrors an output onto a Wayland surface.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ twitchyliquid64 ];
    platforms = platforms.linux;
  };
}
