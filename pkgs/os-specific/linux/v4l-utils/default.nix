{
  stdenv,
  lib,
  fetchurl,
  glibc,
  clang,
  doxygen,
  meson,
  ninja,
  pkg-config,
  perl,
  argp-standalone,
  libjpeg,
  json_c,
  libbpf,
  libelf,
  udev,
  udevCheckHook,
  withUtils ? true,
  withGUI ? true,
  alsa-lib,
  libGLU,
  qt6Packages,
  linuxHeaders,
  buildPackages,
}:

# See libv4l in all-packages.nix for the libs only (overrides alsa, QT)

let
  withQt = withUtils && withGUI;

in
# we need to use stdenv.mkDerivation in order not to pollute the libv4l’s closure with Qt
stdenv.mkDerivation (finalAttrs: {
  pname = "v4l-utils";
  version = "1.30.1";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/v4l-utils/v4l-utils-${finalAttrs.version}.tar.xz";
    hash = "sha256-wc9UnC7DzznrXse/FXMTSeYbJqIbXpY5IttCIzO64Zc=";
  };

  patches = [
    # Has been submitted upstream, but can't fetchurl/fetchpatch
    # because patch doesn't know how to decode quoted-printable.
    # https://lore.kernel.org/all/4dgJekVdP7lLqOQ6JNW05sRHSkRmLLMMQnEn8NGUHPoHDn4SBkaGlHUW89vkJJu3IeFDAh3p6mlplTJJlWJx8V4rr62-hd83quCJ2sIuqoA=@protonmail.com/
    ./musl.patch
  ];

  outputs = [
    "out"
  ]
  ++ lib.optional withUtils "lib"
  ++ [
    "doc"
    "dev"
  ];

  mesonFlags = [
    (lib.mesonBool "v4l-utils" withUtils)
    (lib.mesonEnable "gconv" stdenv.hostPlatform.isGnu)
    (lib.mesonEnable "qv4l2" withQt)
    (lib.mesonEnable "qvidcap" withQt)
    (lib.mesonOption "udevdir" "${placeholder "out"}/lib/udev")
  ]
  ++ lib.optionals stdenv.hostPlatform.isGnu [
    (lib.mesonOption "gconvsysdir" "${glibc.out}/lib/gconv")
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # BPF support fail to cross compile, unable to find `linux/lirc.h`
    (lib.mesonOption "bpf" "disabled")
  ];

  postFixup = ''
    # Create symlink for V4l1 compatibility
    ln -s "$dev/include/libv4l1-videodev.h" "$dev/include/videodev.h"
  '';

  nativeBuildInputs = [
    clang
    doxygen
    meson
    ninja
    pkg-config
    perl
    udevCheckHook
  ]
  ++ lib.optional withQt qt6Packages.wrapQtAppsHook;

  buildInputs = [
    json_c
    libbpf
    libelf
    udev
  ]
  ++ lib.optional (!stdenv.hostPlatform.isGnu) argp-standalone
  ++ lib.optionals withQt [
    alsa-lib
    qt6Packages.qt5compat
    qt6Packages.qtbase
    libGLU
  ];

  hardeningDisable = [ "zerocallusedregs" ];

  propagatedBuildInputs = [ libjpeg ];

  # these two `substituteInPlace` have been sent upstream as patches
  # https://lore.kernel.org/linux-media/867c4d2e-7871-4280-8c89-d4b654597f32@public-files.de/T/
  # they might fail and have to be removed once the patches get accepted
  postPatch = ''
    patchShebangs utils/
    substituteInPlace \
      lib/libdvbv5/meson.build \
      --replace-fail "install_dir: 'include/libdvbv5'" "install_dir: get_option('includedir') / 'libdvbv5'"
    substituteInPlace \
      meson.build \
      --replace-fail "get_option('datadir') / 'locale'" "get_option('localedir')"
  '';

  # Meson unable to find moc/uic/rcc in case of cross-compilation
  # https://github.com/mesonbuild/meson/issues/13018
  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    export PATH=${buildPackages.qt6Packages.qtbase}/libexec:$PATH
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;

  meta = with lib; {
    description = "V4L utils and libv4l, provide common image formats regardless of the v4l device";
    homepage = "https://linuxtv.org/projects.php";
    changelog = "https://git.linuxtv.org/v4l-utils.git/plain/ChangeLog?h=v4l-utils-${finalAttrs.version}";
    license = with licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with maintainers; [
      codyopel
      yarny
    ];
    platforms = platforms.linux;
  };
})
