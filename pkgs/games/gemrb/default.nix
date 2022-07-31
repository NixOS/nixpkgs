{ lib
, stdenv
, fetchFromGitHub
, cmake
, SDL2
, SDL2_mixer
, freetype
, libGL
, libiconv
, libpng
, libvlc
, libvorbis
, openal
, python2 # 0.9.0 crashes after character generation with py3, so stick to py2 for now
, zlib
}:

let
  # the GLES backend on rpi is untested as I don't have the hardware
  backend =
    if stdenv.hostPlatform.isx86 then "OpenGL" else "GLES";

  withVLC = stdenv.isDarwin;

  inherit (lib) optional optionalString;

in
stdenv.mkDerivation rec {
  pname = "gemrb";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "gemrb";
    repo = "gemrb";
    rev = "v${version}";
    sha256 = "sha256-h/dNPY0QZ2m7aYgRla3r1E8APJqO99ePa2ABhhh3Aoc=";
  };

  buildInputs = [
    SDL2
    SDL2_mixer
    freetype
    libGL
    libiconv
    libpng
    libvorbis
    openal
    python2
    zlib
  ]
  ++ optional withVLC libvlc;

  nativeBuildInputs = [ cmake ];

  # libvlc isn't being detected properly as of 0.9.0, so set it
  LIBVLC_INCLUDE_PATH = optionalString withVLC "${lib.getDev libvlc}/include";
  LIBVLC_LIBRARY_PATH = optionalString withVLC "${lib.getLib libvlc}/lib";

  cmakeFlags = [
    "-DDATA_DIR=${placeholder "out"}/share/gemrb"
    "-DEXAMPLE_CONF_DIR=${placeholder "out"}/share/doc/gemrb/examples"
    "-DSYSCONF_DIR=/etc"
    # use the Mesa drivers for video on ARM (harmless on x86)
    "-DDISABLE_VIDEOCORE=ON"
    "-DLAYOUT=opt"
    "-DOPENGL_BACKEND=${backend}"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  postInstall = ''
    for s in 36 48 72 96 144; do
      install -Dm444 ../artwork/gemrb-logo-glow-''${s}px.png $out/share/icons/hicolor/''${s}x''${s}/gemrb.png
    done
    install -Dm444 ../artwork/gemrb-logo.png $out/share/icons/gemrb.png
  '';

  meta = with lib; {
    description = "A reimplementation of the Infinity Engine, used by games such as Baldur's Gate";
    longDescription = ''
      GemRB (Game engine made with pre-Rendered Background) is a portable
      open-source implementation of Bioware's Infinity Engine. It was written to
      support pseudo-3D role playing games based on the Dungeons & Dragons
      ruleset (Baldur's Gate and Icewind Dale series, Planescape: Torment).
    '';
    homepage = "https://gemrb.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
