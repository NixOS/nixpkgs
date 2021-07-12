{ lib, stdenv, fetchFromGitHub, which, pkg-config, makeWrapper
, ffmpeg, libGLU, libGL, freetype, libxml2, python3
, libobjc, AppKit, Foundation
, alsa-lib ? null
, libdrm ? null
, libpulseaudio ? null
, libv4l ? null
, libX11 ? null
, libXdmcp ? null
, libXext ? null
, libXxf86vm ? null
, mesa ? null
, SDL2 ? null
, udev ? null
, enableNvidiaCgToolkit ? false, nvidia_cg_toolkit ? null
, withVulkan ? stdenv.isLinux, vulkan-loader ? null
, fetchurl
, wayland
, libxkbcommon
}:

with lib;

stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    sha256 = "1pg8j9wvwgrzsv4xdai6i6jgdcc922v0m42rbqxvbghbksrc8la3";
    rev = "v${version}";
  };

  nativeBuildInputs = [ pkg-config wayland ]
                      ++ optional withVulkan makeWrapper;

  buildInputs = [ ffmpeg freetype libxml2 libGLU libGL python3 SDL2 which ]
                ++ optional enableNvidiaCgToolkit nvidia_cg_toolkit
                ++ optional withVulkan vulkan-loader
                ++ optionals stdenv.isDarwin [ libobjc AppKit Foundation ]
                ++ optionals stdenv.isLinux [ alsa-lib libdrm libpulseaudio libv4l libX11
                                              libXdmcp libXext libXxf86vm mesa udev
                                              wayland libxkbcommon ];

  enableParallelBuilding = true;

  configureFlags = lib.optionals stdenv.isLinux [ "--enable-kms" "--enable-egl" ];

  postInstall = optionalString withVulkan ''
    wrapProgram $out/bin/retroarch --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
  '';

  preFixup = "rm $out/bin/retroarch-cg2glsl";

  meta = {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ MP2E edwtjo matthewbauer kolbycrouch ];
  };
}
