{ stdenv, fetchFromGitHub, cmake
, freetype, SDL2, SDL2_mixer, openal, zlib, libpng, python, libvorbis
, libiconv }:

stdenv.mkDerivation rec {
  pname = "gemrb";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "gemrb";
    repo = "gemrb";
    rev = "v${version}";
    sha256 = "14j9mhrbi4gnrbv25nlsvcxzkylijzrnwbqqnrg7pr452lb3srpb";
  };

  # TODO: make libpng, libvorbis, sdl_mixer, freetype, vlc, glew (and other gl
  # reqs) optional
  buildInputs = [ freetype python openal SDL2 SDL2_mixer zlib libpng libvorbis libiconv ];

  nativeBuildInputs = [ cmake ];

  # TODO: add proper OpenGL support. We are currently (0.8.7) getting a shader
  # error on execution when enabled.
  cmakeFlags = [
    "-DLAYOUT=opt"
    # "-DOPENGL_BACKEND=GLES"
    # "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  meta = with stdenv.lib; {
    description = "A reimplementation of the Infinity Engine, used by games such as Baldur's Gate";
    longDescription = ''
      GemRB (Game engine made with pre-Rendered Background) is a portable
      open-source implementation of Bioware's Infinity Engine. It was written to
      support pseudo-3D role playing games based on the Dungeons & Dragons
      ruleset (Baldur's Gate and Icewind Dale series, Planescape: Torment).
    '';
    homepage = "https://gemrb.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
