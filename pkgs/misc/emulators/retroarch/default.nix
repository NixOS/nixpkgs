{ lib
, stdenv
, enableNvidiaCgToolkit ? false
, withVulkan ? stdenv.isLinux
, alsa-lib
, AppKit
, fetchFromGitHub
, ffmpeg
, Foundation
, freetype
, libdrm
, libGL
, libGLU
, libobjc
, libpulseaudio
, libv4l
, libX11
, libXdmcp
, libXext
, libxkbcommon
, libxml2
, libXxf86vm
, makeWrapper
, mesa
, nvidia_cg_toolkit
, pkg-config
, python3
, SDL2
, substituteAll
, udev
, vulkan-loader
, wayland
, which
}:

with lib;

let
  libretroSuperSrc = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-super";
    sha256 = "sha256-4WB6/1DDec+smhMJKLCxWb4+LQlZN8v2ik69saKixkE=";
    rev = "fa70d9843838df719623094965bd447e4db0d1b4";
  };
in
stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  version = "1.9.13.2";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    sha256 = "sha256-fehHchn+o9QM2wIK6zYamnbFvQda32Gw0rJk8Orx00U=";
    rev = "v${version}";
  };

  patches = [
    # FIXME: The `retroarch.cfg` file is created once in the first run and only
    # updated when needed. However, the file may have out-of-date paths
    # In case of issues (e.g.: cores are not loading), please delete the
    # `$XDG_CONFIG_HOME/retroarch/retroarch.cfg` file
    # See: https://github.com/libretro/RetroArch/issues/13251
    ./fix-config.patch
  ];

  postPatch = ''
    substituteInPlace retroarch.cfg \
      --replace "@libretro_directory@" "$out/lib" \
      --replace "@libretro_info_path@" "$out/share/libretro/info" \
  '';

  nativeBuildInputs = [ pkg-config wayland ] ++
    optional withVulkan makeWrapper;

  buildInputs = [ ffmpeg freetype libxml2 libGLU libGL python3 SDL2 which ] ++
    optional enableNvidiaCgToolkit nvidia_cg_toolkit ++
    optional withVulkan vulkan-loader ++
    optionals stdenv.isDarwin [ libobjc AppKit Foundation ] ++
    optionals stdenv.isLinux [
      alsa-lib
      libdrm
      libpulseaudio
      libv4l
      libX11
      libXdmcp
      libXext
      libXxf86vm
      mesa
      udev
      wayland
      libxkbcommon
    ];

  enableParallelBuilding = true;

  configureFlags = lib.optionals stdenv.isLinux [ "--enable-kms" "--enable-egl" ];

  postInstall = optionalString withVulkan ''
    mkdir -p $out/share/libretro/info
    # TODO: ideally each core should have its own core information
    cp -r ${libretroSuperSrc}/dist/info/* $out/share/libretro/info
    wrapProgram $out/bin/retroarch --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
  '';

  preFixup = "rm $out/bin/retroarch-cg2glsl";

  meta = {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ MP2E edwtjo matthewbauer kolbycrouch thiagokokada ];
  };
}
