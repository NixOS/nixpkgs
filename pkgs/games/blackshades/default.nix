{ lib
, stdenv
, fetchFromSourcehut
, glfw
, libGL
, libGLU
, libsndfile
, openal
, zig_0_9
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackshades";
  version = "2.4.9";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "blackshades";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-Hg+VcWI28GzY/CPm1lUftP0RGztOnzizrKJQVTmeJ9I=";
  };

  nativeBuildInputs = [ zig_0_9.hook ];

  buildInputs = [
    glfw
    libGLU
    libGL
    libsndfile
    openal
  ];

  meta = {
    homepage = "https://sr.ht/~cnx/blackshades";
    description = "A psychic bodyguard FPS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ McSinyx viric ];
    platforms = lib.platforms.linux;
  };
})
