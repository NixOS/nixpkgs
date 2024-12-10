{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtm";
  version = "0.9.81";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/PVZr87w4Iu44355U9YH51jWF+mNPZvdyfYKJvOLDJU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Terminal multiplexer with window manager and session sharing";
    homepage = "https://vtm.netxs.online/";
    license = lib.licenses.mit;
    mainProgram = "vtm";
    maintainers = with lib.maintainers; [ ahuzik ];
    platforms = lib.platforms.all;
  };
})
