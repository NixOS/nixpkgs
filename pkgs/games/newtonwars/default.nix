{ stdenv, fetchFromGitHub, makeWrapper, freeglut, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "newtonwars-${version}";
  version = "20150609";

  src = fetchFromGitHub {
    owner = "Draradech";
    repo = "NewtonWars";
    rev = "98bb99a1797fd0073e0fd25ef9218468d3a9f7cb";
    sha256 = "0g63fwfcdxxlnqlagj1fb8ngm385gmv8f7p8b4r1z5cny2znxdvs";
  };

  buildInputs = [ makeWrapper freeglut libGLU_combined ];

  patchPhase = ''
    sed -i "s;font24.raw;$out/share/font24.raw;g" display.c
  '';

  buildPhase = "sh build-linux.sh";

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp nw $out/bin
    cp font24.raw $out/share

    wrapProgram $out/bin/nw \
      --prefix LD_LIBRARY_PATH ":" ${freeglut}/lib \
      --prefix LD_LIBRARY_PATH ":" ${libGLU_combined}/lib
  '';

  meta = with stdenv.lib; {
    description = "A space battle game with gravity as the main theme";
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
