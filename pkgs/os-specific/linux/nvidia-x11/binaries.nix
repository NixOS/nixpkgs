{
  # Package dependencies
  lib,
  stdenv,
  which,
  jq,
  pkgs,
  pkgsi686Linux,
  # The unpacked driver installer, shared with the kernel module build.
  src,
  # Whether to build only userspace libraries (without bin/firmware outputs)
  libsOnly,
  # don't include the bundled 32-bit libraries on 64-bit platforms,
  # even if it's in downloaded binary
  disable32Bit ? stdenv.hostPlatform.system == "aarch64-linux",
  # 32 bit libs only version of this package
  lib32,
  # Whether to extract the GSP firmware; datacenter drivers and open
  # kernel module builds need it
  firmware ? openSha256 != null || useFabricmanager,
  # Hash for open kernel modules; if non-null, allows building
  # without accepting the proprietary license
  openSha256,
  # Driver version and sources
  version,
  sha256_32bit,
  sha256_aarch64,
  # Feature flags
  useGLVND,
  useProfiles,
  # Whether this is a datacenter driver (affects pname)
  useFabricmanager,
  # Whether this driver supports ibt
  ibtSupport,
  # Build customization
  prePatch,
  postPatch,
  patchFlags,
  patches,
  preInstall,
  postInstall,
  ...
}:

assert lib.versionOlder version "391" -> sha256_32bit != null;

let
  # Create a library path string for the given package set
  libPathFor =
    pkgs:
    lib.makeLibraryPath (
      with pkgs;
      [
        libdrm
        libxext
        libx11
        libxv
        libxrandr
        libxcb
        zlib
        stdenv.cc.cc
        wayland
        libgbm
        libGL
        openssl
        dbus # for nvidia-powerd
      ]
    );

  i686bundled = lib.versionAtLeast version "391" && !disable32Bit;

  libPath = libPathFor pkgs;
  libPath32 = lib.optionalString i686bundled (libPathFor pkgsi686Linux);

in

stdenv.mkDerivation (finalAttrs: {
  pname = "nvidia-${if useFabricmanager then "dc" else "x11"}";

  builder = ./builder.sh;

  inherit src;

  patches = if libsOnly then null else patches;
  inherit prePatch postPatch patchFlags;
  inherit preInstall postInstall;
  inherit version useGLVND useProfiles;
  inherit (stdenv.hostPlatform) system;
  inherit i686bundled;

  outputs = [
    "out"
  ]
  ++ lib.optional i686bundled "lib32"
  ++ lib.optionals (!libsOnly) [ "bin" ]
  ++ lib.optional (!libsOnly && firmware) "firmware";
  outputDev = if libsOnly then null else "bin";

  dontStrip = true;
  dontPatchELF = true;

  inherit libPath libPath32;

  nativeBuildInputs = [
    jq
  ]
  # Drivers older than 530 need `which` in the build, see
  # https://github.com/NixOS/nixpkgs/pull/498612#discussion_r3064133935
  ++ lib.optional (lib.versionOlder version "530") [ which ];

  passthru = {
    compressFirmware = false;
    ibtSupport = ibtSupport || (lib.versionAtLeast version "530");
  }
  // lib.optionalAttrs (!i686bundled) {
    inherit lib32;
  };

  meta = {
    homepage = "https://www.nvidia.com/object/unix.html";
    description = "${
      if useFabricmanager then "Data Center" else "X.org"
    } userspace driver and tools for NVIDIA cards";
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "x86_64-linux"
    ]
    ++ lib.optionals (sha256_32bit != null) [ "i686-linux" ]
    ++ lib.optionals (sha256_aarch64 != null) [ "aarch64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryFirmware
    ];
    maintainers = with lib.maintainers; [
      kiskae
      edwtjo
    ];
    priority = 4; # resolves collision with xorg-server's "lib/xorg/modules/extensions/libglx.so"
  };
})
