<<<<<<< HEAD
{ lib
, stdenv
, fetchFromSourcehut
, glfw
, libGL
, libGLU
, libsndfile
, openal
, zig_0_11
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackshades";
  version = "2.5.1";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "blackshades";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-qdpXpuXHr9w2XMfgOVveWv3JoqdJHVB8TCqZdyaw/DM=";
  };

  nativeBuildInputs = [ zig_0_11.hook ];

  buildInputs = [
    glfw
    libGLU
    libGL
    libsndfile
    openal
  ];
=======
{ lib, stdenv, fetchFromSourcehut
, zig, glfw, libGLU, libGL, openal, libsndfile }:

stdenv.mkDerivation rec {
  pname = "blackshades";
  version = "2.4.9";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-Hg+VcWI28GzY/CPm1lUftP0RGztOnzizrKJQVTmeJ9I=";
  };

  nativeBuildInputs = [ zig ];
  buildInputs = [ glfw libGLU libGL openal libsndfile ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    zig build -Drelease-fast -Dcpu=baseline --prefix $out install
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    homepage = "https://sr.ht/~cnx/blackshades";
    description = "A psychic bodyguard FPS";
<<<<<<< HEAD
    changelog = "https://git.sr.ht/~cnx/blackshades/refs/${finalAttrs.version}";
    mainProgram = "blackshades";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ McSinyx viric ];
    platforms = lib.platforms.linux;
  };
})
=======
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ McSinyx viric ];
    platforms = with lib.platforms; linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
