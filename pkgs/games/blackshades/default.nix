{ lib, stdenv, fetchFromSourcehut
, zig, glfw, libGLU, libGL, openal, libsndfile }:

stdenv.mkDerivation rec {
  pname = "blackshades";
  version = "2.4.7";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-hvJwWUUmGeb7MQgKe79cPS2ckPZ9z0Yc5S9IiwuXPD8=";
  };

  nativeBuildInputs = [ zig ];
  buildInputs = [ glfw libGLU libGL openal libsndfile ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    zig build -Drelease-fast -Dcpu=baseline --prefix $out install
  '';

  meta = {
    homepage = "https://sr.ht/~cnx/blackshades";
    description = "A psychic bodyguard FPS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ McSinyx viric ];
    platforms = with lib.platforms; linux;
  };
}
