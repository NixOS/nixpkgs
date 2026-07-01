# This file provides the core logic for extracting and installing files from
# the proprietary NVIDIA driver installer (.run file).
#
# It is separated from the extra packages (settings, persistenced,
# fabricmanager, kernel modules) that are defined in generic.nix and exposed
# via passthru.
#
# This file is designed to be invoked via callPackage so that its package
# dependencies are resolved automatically from the package set.  The
# driver-specific arguments (version, hashes, feature flags, …) are passed
# as the second argument to callPackage.
#
# Parameters without defaults are always provided by generic.nix via args.
# Only disable32Bit, firmware, and acceptLicense keep their defaults here.

{
  # Package dependencies (auto-resolved by callPackage)
  lib,
  stdenv,
  fetchurl,
  which,
  libarchive,
  jq,
  zstd,
  pkgs,
  pkgsi686Linux,
  config,
  # Whether to build only userspace libraries (without bin/modsrc/firmware outputs)
  libsOnly,
  # don't include the bundled 32-bit libraries on 64-bit platforms,
  # even if it's in downloaded binary
  disable32Bit ? stdenv.hostPlatform.system == "aarch64-linux",
  # 32 bit libs only version of this package
  lib32,
  # Whether to extract the GSP firmware; datacenter drivers and open
  # kernel module builds need it
  firmware ? openSha256 != null || useFabricmanager,
  # Whether the user accepts the NVIDIA Software License
  acceptLicense ? config.nvidia.acceptLicense or false,
  # Hash for open kernel modules; if non-null, allows building
  # without accepting the proprietary license
  openSha256,
  # Driver version and sources
  version,
  url,
  sha256_32bit,
  sha256_64bit,
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
  # Whether the build is marked broken
  broken,
  brokenOpen,
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

  # Throw an error about license acceptance
  throwLicense = throw ''
    Use of NVIDIA Software requires license acceptance of the license:

      - License For Customer Use of NVIDIA Software [1]

    You can express acceptance by setting acceptLicense to true your nixpkgs.config.
    Example:

      configuration.nix:
        nixpkgs.config.allowUnfree = true;
        nixpkgs.config.nvidia.acceptLicense = true;

      config.nix:
        allowUnfree = true;
        nvidia.acceptLicense = true;

    [1]: https://www.nvidia.com/content/DriverDownloads/licence.php?lang=us
  '';

  pkgSuffix = lib.optionalString (lib.versionOlder version "304") "-pkg0";
  i686bundled = lib.versionAtLeast version "391" && !disable32Bit;

  libPath = libPathFor pkgs;
  libPath32 = lib.optionalString i686bundled (libPathFor pkgsi686Linux);

  src =
    if !acceptLicense && (openSha256 == null) then
      throwLicense
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        urls =
          if url != null then
            [ url ]
          else
            [
              "https://us.download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}${pkgSuffix}.run"
              "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}${pkgSuffix}.run"
            ];
        sha256 = sha256_64bit;
      }
    else if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        urls =
          if url != null then
            [ url ]
          else
            [
              "https://us.download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}${pkgSuffix}.run"
              "https://download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}${pkgSuffix}.run"
            ];
        sha256 = sha256_32bit;
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" && sha256_aarch64 != null then
      fetchurl {
        urls =
          if url != null then
            [ url ]
          else
            [
              "https://us.download.nvidia.com/XFree86/aarch64/${version}/NVIDIA-Linux-aarch64-${version}${pkgSuffix}.run"
              "https://download.nvidia.com/XFree86/Linux-aarch64/${version}/NVIDIA-Linux-aarch64-${version}${pkgSuffix}.run"
            ];
        sha256 = sha256_aarch64;
      }
    else
      throw "nvidia-x11 does not support platform ${stdenv.hostPlatform.system}";

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
  ++ lib.optionals (!libsOnly) [
    "bin"
    "modsrc"
  ]
  ++ lib.optional (!libsOnly && firmware) "firmware";
  outputDev = if libsOnly then null else "bin";

  dontStrip = true;
  dontPatchELF = true;

  inherit libPath libPath32;

  nativeBuildInputs = [
    libarchive
    jq
  ]
  # NVIDIA has changed the compression format of their driver to zstd since version 530.30.02
  # https://forums.developer.nvidia.com/t/linux-solaris-and-freebsd-driver-530-30-02-beta/244406
  ++ (if (lib.versionAtLeast version "530") then [ zstd ] else [ which ]);

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
    } driver and kernel module for NVIDIA cards";
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
    broken = broken && brokenOpen;
  };
})
