{ stdenv, fetchFromGitHub, which, pkgconfig, makeWrapper
, ffmpeg, libGLU_combined, freetype, libxml2, python34
, libobjc, AppKit, Foundation
, alsaLib ? null
, libpulseaudio ? null
, libv4l ? null
, libX11 ? null
, libXdmcp ? null
, libXext ? null
, libXxf86vm ? null
, SDL2 ? null
, udev ? null
, enableNvidiaCgToolkit ? false, nvidia_cg_toolkit ? null
, withVulkan ? stdenv.isLinux, vulkan-loader ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "retroarch-bare-${version}";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    sha256 = "0qv8ci76f5kwv5b49ijgpc6jdfp6sm21fw5hq06mq6ygyiy9vdzf";
    rev = "v${version}";
  };

  nativeBuildInputs = [ pkgconfig ]
                      ++ optional withVulkan [ makeWrapper ];

  buildInputs = [ ffmpeg freetype libxml2 libGLU_combined python34 SDL2 which ]
                ++ optional enableNvidiaCgToolkit nvidia_cg_toolkit
                ++ optional withVulkan [ vulkan-loader ]
                ++ optionals stdenv.isDarwin [ libobjc AppKit Foundation ]
                ++ optionals stdenv.isLinux [ alsaLib libpulseaudio libv4l libX11
                                              libXdmcp libXext libXxf86vm udev ];

  enableParallelBuilding = true;

  postInstall = optional withVulkan ''
    wrapProgram $out/bin/retroarch --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
  '';

  preFixup = "rm $out/bin/retroarch-cg2glsl";

  meta = {
    homepage = https://libretro.com;
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ MP2E edwtjo matthewbauer ];
  };
}
