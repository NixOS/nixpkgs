{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libGLU,
  libglut,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "twilight";
  version = "unstable-2018-04-19";

  src = fetchFromGitHub {
    owner = "tweakoz";
    repo = "twilight";
    rev = "43f21d15c2a8923c9d707bdf3789f480bfd4b36d";
    sha256 = "0mmmi4jj8yd8wnah6kx5na782sjycszgzim33dfalr0ph361m4pz";
  };

  buildInputs = [
    libGL
    libGLU
    libglut
    libX11
  ];

  installPhase = ''
    install -Dm755 twilight $out/bin/twilight
  '';

  meta = with lib; {
    description = "Redo of IRIX twilight backdrop in old school OpenGL";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "twilight";
  };
}
