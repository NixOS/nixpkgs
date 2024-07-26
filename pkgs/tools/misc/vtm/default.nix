{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtm";
  version = "0.9.74";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O8fnh8I3KbiOD40bU0eO7tbvpMoSCVonKPVFx5pynR4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [ "../src" ];

  meta = {
    description = "Terminal multiplexer with window manager and session sharing";
    homepage = "https://vtm.netxs.online/";
    license = lib.licenses.mit;
    mainProgram = "vtm";
    maintainers = with lib.maintainers; [ ahuzik ];
    platforms = lib.platforms.all;
  };
})
