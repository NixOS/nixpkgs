{ stdenv, fetchFromGitHub, libX11, freeglut, glew, libXNVCtrl, libXext, lib }:

stdenv.mkDerivation rec {
  pname = "gl-gsync-demo";
  version = "unstable-2020-12-27";

  src = fetchFromGitHub {
    owner = "dahenry";
    repo = "gl-gsync-demo";
    rev = "4fd963a8ad880dc2d846394c8c80b2091a119591";
    sha256 = "1innsmpsd9n9ih80v16rhj2ijrl28jd7x6a4jmxdirba7mjibm8d";
  };

  buildInputs = [ libX11 freeglut glew libXNVCtrl libXext ];

  installPhase = ''
    runHook preInstall

    install -D gl-gsync-demo -t $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    license = with licenses; mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ atemu ];
    description = "A very basic OpenGL demo for testing NVIDIA's G-SYNC technology on Linux";
    mainProgram = "gl-gsync-demo";
    longDescription = ''
      The demo simply draws a vertical bar moving across the screen at constant speed, but deliberately rendered at a variable frame rate.

      The min and max frame rates can be manually changed at runtime, by step of 10 fps and with a min of 10 fps.

      The demo also allows to toggle V-Sync on/off.
    '';
    homepage = "https://github.com/dahenry/gl-gsync-demo";
  };
}
