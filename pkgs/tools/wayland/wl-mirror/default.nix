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
, installExampleScripts ? true
, makeWrapper
, pipectl
, slurp
, rofi
}:

let
  wl-present-binpath = lib.makeBinPath [
    pipectl
    rofi
    slurp
    (placeholder "out")
  ];
in

stdenv.mkDerivation rec {
  pname = "wl-mirror";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "wl-mirror";
    rev = "v${version}";
    hash = "sha256-W/8DApyd7KtrOrP7Qj6oPKXxLrVzHDuIMOdg+k5ngr4=";
  };

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace 'WL_PROTOCOL_DIR "/usr' 'WL_PROTOCOL_DIR "${wayland-protocols}' \
      --replace 'WLR_PROTOCOL_DIR "/usr' 'WLR_PROTOCOL_DIR "${wlr-protocols}'
  '';

  cmakeFlags = [
    "-DINSTALL_EXAMPLE_SCRIPTS=${if installExampleScripts then "ON" else "OFF"}"
  ];

  postInstall = lib.optionalString installExampleScripts ''
    wrapProgram $out/bin/wl-present --prefix PATH ":" ${wl-present-binpath}
  '';

  nativeBuildInputs = [ cmake pkg-config wayland-scanner makeWrapper ];
  buildInputs = [ libGL wayland wayland-protocols wlr-protocols ];

  meta = with lib; {
    homepage = "https://github.com/Ferdi265/wl-mirror";
    description = "Mirrors an output onto a Wayland surface.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ synthetica twitchyliquid64 ];
    platforms = platforms.linux;
  };
}
