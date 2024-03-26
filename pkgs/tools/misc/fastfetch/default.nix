{ lib
, stdenv
, fetchFromGitHub
, chafa
, cmake
, darwin
, dbus
, dconf
, ddcutil
, glib
, imagemagick_light
, libXrandr
, libglvnd
, libpulseaudio
, libselinux
, libsepol
, libxcb
, makeBinaryWrapper
, networkmanager
, nix-update-script
, ocl-icd
, opencl-headers
, pciutils
, pcre
, pcre2
, pkg-config
, python3
, rpm
, sqlite
, testers
, util-linux
, vulkan-loader
, wayland
, xfce
, xorg
, yyjson
, zlib
, rpmSupport ? false
, vulkanSupport ? true
, waylandSupport ? true
, x11Support ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.8.10";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = finalAttrs.version;
    hash = "sha256-MIrjfd1KudtU+4X65M+qdPtWUPWQXBlE13Myp1u8hPM=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    chafa
    imagemagick_light
    pcre
    pcre2
    sqlite
    yyjson
  ] ++ lib.optionals stdenv.isLinux [
    dbus
    dconf
    ddcutil
    glib
    libpulseaudio
    libselinux
    libsepol
    networkmanager
    ocl-icd
    opencl-headers
    pciutils
    util-linux
    zlib
  ] ++ lib.optionals rpmSupport [
    rpm
  ] ++ lib.optionals vulkanSupport [
    vulkan-loader
  ] ++ lib.optionals waylandSupport [
    wayland
  ] ++ lib.optionals x11Support [
    libXrandr
    libglvnd
    libxcb
    xorg.libXau
    xorg.libXdmcp
    xorg.libXext
  ] ++ lib.optionals (x11Support && (!stdenv.isDarwin)) [
    xfce.xfconf
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    Apple80211
    AppKit
    AVFoundation
    Cocoa
    CoreDisplay
    CoreVideo
    CoreWLAN
    DisplayServices
    IOBluetooth
    MediaRemote
    OpenCL
    SystemConfiguration
    darwin.moltenvk
  ]);

  cmakeFlags = [
    (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
    (lib.cmakeBool "ENABLE_DIRECTX_HEADERS" false)
    (lib.cmakeBool "ENABLE_DRM" false)
    (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
    (lib.cmakeBool "ENABLE_OSMESA" false)
    (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)
    (lib.cmakeBool "ENABLE_GLX" x11Support)
    (lib.cmakeBool "ENABLE_RPM" rpmSupport)
    (lib.cmakeBool "ENABLE_VULKAN" x11Support)
    (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)
    (lib.cmakeBool "ENABLE_X11" x11Support)
    (lib.cmakeBool "ENABLE_XCB" x11Support)
    (lib.cmakeBool "ENABLE_XCB_RANDR" x11Support)
    (lib.cmakeBool "ENABLE_XFCONF" (x11Support && (!stdenv.isDarwin)))
    (lib.cmakeBool "ENABLE_XRANDR" x11Support)
  ];

  postInstall = ''
    wrapProgram $out/bin/fastfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    wrapProgram $out/bin/flashfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "fastfetch -v | cut -d '(' -f 1";
      version = "fastfetch ${finalAttrs.version}";
    };
  };

  meta = {
    description = "Like neofetch, but much faster because written in C";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gerg-l khaneliman federicoschonborn ];
    platforms = lib.platforms.all;
    mainProgram = "fastfetch";
  };
})
