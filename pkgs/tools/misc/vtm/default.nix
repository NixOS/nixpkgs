{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtm";
  version = "0.9.83";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sdzL5qTYcmMFqZmjsGS/nA7gMtUmzjUg8aiKva0v9dw=";
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
