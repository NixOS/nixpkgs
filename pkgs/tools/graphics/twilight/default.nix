{ stdenv, fetchFromGitHub
, libGL, libGLU, freeglut, libX11 }:

let
  version = "2018-04-19";
in stdenv.mkDerivation rec {
  name = "twilight-${version}";

  src = fetchFromGitHub {
    owner = "tweakoz";
    repo = "twilight";
    rev = "43f21d15c2a8923c9d707bdf3789f480bfd4b36d";
    sha256 = "0mmmi4jj8yd8wnah6kx5na782sjycszgzim33dfalr0ph361m4pz";
  };

  buildInputs = [ libGL libGLU freeglut libX11 ];

  installPhase = ''
    install -Dm755 twilight $out/bin/twilight
  '';

  meta = with stdenv.lib; {
    description = "Redo of IRIX twilight backdrop in old school OpenGL";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
