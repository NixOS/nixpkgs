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
, libglvnd
, libpulseaudio
, libxcb
, libXrandr
, makeBinaryWrapper
, networkmanager
, nix-update-script
, ocl-icd
, opencl-headers
, pciutils
, pkg-config
, rpm
, sqlite
, testers
, vulkan-loader
, wayland
, xfce
, yyjson
, zlib
, vulkanSupport ? true
, waylandSupport ? true
, x11Support ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = finalAttrs.version;
    hash = "sha256-s0N3Rt3lLOCyaeXeNYu6hlGtNtGR+YC7Aj4/3SeVMpQ=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    chafa
    imagemagick_light
    sqlite
    yyjson
  ]
  ++ lib.optionals stdenv.isLinux [
    dbus
    dconf
    ddcutil
    glib
    libpulseaudio
    networkmanager
    ocl-icd
    opencl-headers
    pciutils
    rpm
    zlib
  ] ++ lib.optionals vulkanSupport [
    vulkan-loader
  ] ++ lib.optionals waylandSupport [
    wayland
  ] ++ lib.optionals x11Support [
    libXrandr
    libglvnd
    libxcb
  ] ++ lib.optionals (x11Support && (!stdenv.isDarwin))  [
    xfce.xfconf
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    Apple80211
    AppKit
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
    (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)
    (lib.cmakeBool "ENABLE_GLX" x11Support)
    (lib.cmakeBool "ENABLE_VULKAN" x11Support)
    (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)
    (lib.cmakeBool "ENABLE_X11" x11Support)
    (lib.cmakeBool "ENABLE_XCB" x11Support)
    (lib.cmakeBool "ENABLE_XCB_RANDR" x11Support)
    (lib.cmakeBool "ENABLE_XFCONF" (x11Support && (!stdenv.isDarwin)))
    (lib.cmakeBool "ENABLE_XRANDR" x11Support)
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=uninitialized"
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
