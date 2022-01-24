{ lib
, stdenv
, enableNvidiaCgToolkit ? false
, withGamemode ? stdenv.isLinux
, withVulkan ? stdenv.isLinux
, alsa-lib
, AppKit
, fetchFromGitHub
, ffmpeg
, Foundation
, freetype
, gamemode
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
, udev
, vulkan-loader
, wayland
, which
}:

let
  version = "1.10.0";
  libretroCoreInfo = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    sha256 = "sha256-3j7fvcfbgyk71MmbUUKYi+/0cpQFNbYXO+DMDUjDqkQ=";
    rev = "v${version}";
  };
  runtimeLibs = lib.optional withVulkan vulkan-loader
    ++ lib.optional withGamemode gamemode.lib;
in
stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  inherit version;

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    sha256 = "sha256-bpTSzODVRKRs1OW6JafjbU3e/AqdQeGzWcg1lb9SIyo=";
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
    lib.optional stdenv.isLinux wayland ++
    lib.optional (runtimeLibs != [ ]) makeWrapper;

  buildInputs = [ ffmpeg freetype libxml2 libGLU libGL python3 SDL2 which ] ++
    lib.optional enableNvidiaCgToolkit nvidia_cg_toolkit ++
    lib.optional withVulkan vulkan-loader ++
    lib.optionals stdenv.isDarwin [ libobjc AppKit Foundation ] ++
    lib.optionals stdenv.isLinux [
      alsa-lib
      libX11
      libXdmcp
      libXext
      libXxf86vm
      libdrm
      libpulseaudio
      libv4l
      libxkbcommon
      mesa
      udev
      wayland
    ];

  enableParallelBuilding = true;

  configureFlags = lib.optionals stdenv.isLinux [ "--enable-kms" "--enable-egl" ];

  postInstall = ''
    mkdir -p $out/share/libretro/info
    # TODO: ideally each core should have its own core information
    cp -r ${libretroCoreInfo}/* $out/share/libretro/info
  '' + lib.optionalString (runtimeLibs != [ ]) ''
    wrapProgram $out/bin/retroarch \
      --prefix LD_LIBRARY_PATH ':' ${lib.makeLibraryPath runtimeLibs}
  '';

  preFixup = "rm $out/bin/retroarch-cg2glsl";

  meta = with lib; {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    changelog = "https://github.com/libretro/RetroArch/blob/v${version}/CHANGES.md";
    maintainers = with maintainers; [ MP2E edwtjo matthewbauer kolbycrouch thiagokokada ];
    # FIXME: exits with error on macOS:
    # No Info.plist file in application bundle or no NSPrincipalClass in the Info.plist file, exiting
    broken = stdenv.isDarwin;
  };
}
