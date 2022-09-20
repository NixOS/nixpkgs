{ stdenv
, fetchFromGitLab
, lib
, cmake
, freeglut
, libGL
, libGLU
, libglvnd
, makeWrapper
, ninja
, pkg-config
, python3
, waffle
, wayland
, libX11
, libXrender
, libxcb
, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "piglit";
  version = "unstable-2020-10-23";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "piglit";
    rev = "59e695c16fdcdd4ea4f16365f0e397a93cef7b80";
    sha256 = "kx0+2Sdvdc3SbpAIl2OuGCWCpaLJC/7cXG+ZLvf92g8=";
  };

  buildInputs = [
    freeglut
    libGL
    libGLU
    libglvnd
    libX11
    libXrender
    libxcb
    libxkbcommon
    (python3.withPackages (ps: with ps; [
      Mako
      numpy
    ]))
    waffle
    wayland
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
  ];

  postInstall = ''
    wrapProgram "$out/bin/piglit" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL libglvnd ]}" \
      --prefix PATH : "${waffle}/bin"
  '';

  meta = with lib; {
    description = "An OpenGL test suite, and test-suite runner";
    homepage = "https://gitlab.freedesktop.org/mesa/piglit";
    license = licenses.free; # custom license. See COPYING in the source repo.
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ Flakebi ];
  };
}
