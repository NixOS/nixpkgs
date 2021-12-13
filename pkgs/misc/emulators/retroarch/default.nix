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
  version = "1.9.14";
  libretroSuperSrc = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    sha256 = "sha256-C2PiBcN5r9NDxFWFE1pytSGR1zq9E5aVt6QUf5aJ7I0=";
    rev = "v${version}";
  };
in
stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  inherit version;

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    sha256 = "sha256-H2fCA1sM8FZfVnLxBjnKe7RjHJNAn/Antxlos5oFFSY=";
    rev = "v${version}";
  };

  patches = [
    ./0001-Disable-menu_show_core_updater.patch
    ./0002-Use-fixed-paths-on-libretro_info_path.patch
  ];

  postPatch = ''
    substituteInPlace "frontend/drivers/platform_unix.c" \
      --replace "@libretro_directory@" "$out/lib" \
      --replace "@libretro_info_path@" "$out/share/libretro/info"
    substituteInPlace "frontend/drivers/platform_darwin.m" \
      --replace "@libretro_directory@" "$out/lib" \
      --replace "@libretro_info_path@" "$out/share/libretro/info"
  '';

  nativeBuildInputs = [ pkg-config ] ++
    optional stdenv.isLinux wayland ++
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
    cp -r ${libretroSuperSrc}/* $out/share/libretro/info
    wrapProgram $out/bin/retroarch --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
  '';

  preFixup = "rm $out/bin/retroarch-cg2glsl";

  meta = {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ MP2E edwtjo matthewbauer kolbycrouch thiagokokada ];
    # FIXME: exits with error on macOS:
    # No Info.plist file in application bundle or no NSPrincipalClass in the Info.plist file, exiting
    broken = stdenv.isDarwin;
  };
}
