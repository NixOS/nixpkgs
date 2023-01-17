{ version
, url ? null
, sha256_32bit ? null
, sha256_64bit
, openSha256 ? null
, settingsSha256
, settingsVersion ? version
, persistencedSha256
, persistencedVersion ? version
, useGLVND ? true
, useProfiles ? true
, preferGtk2 ? false
, settings32Bit ? false

, prePatch ? ""
, patches ? []
, broken ? false
, brokenOpen ? broken
}@args:

{ lib, stdenv, callPackage, pkgs, pkgsi686Linux, fetchurl
, kernel ? null, perl, nukeReferences, which
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
, # don't include the bundled 32-bit libraries on 64-bit platforms,
  # even if it’s in downloaded binary
  disable32Bit ? false
  # 32 bit libs only version of this package
, lib32 ? null
  # Whether to extract the GSP firmware
, firmware ? openSha256 != null
}:

assert !libsOnly -> kernel != null;
assert lib.versionOlder version "391" -> sha256_32bit != null;

let
  nameSuffix = lib.optionalString (!libsOnly) "-${kernel.version}";
  pkgSuffix = lib.optionalString (lib.versionOlder version "304") "-pkg0";
  i686bundled = lib.versionAtLeast version "391" && !disable32Bit;

  libPathFor = pkgs: lib.makeLibraryPath (with pkgs; [
    libdrm xorg.libXext xorg.libX11
    xorg.libXv xorg.libXrandr xorg.libxcb zlib stdenv.cc.cc
    wayland mesa libGL
  ]);

  self = stdenv.mkDerivation {
    name = "nvidia-x11-${version}${nameSuffix}";

    builder = ./builder.sh;

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = args.url or "https://us.download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}${pkgSuffix}.run";
          sha256 = sha256_64bit;
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = args.url or "https://download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}${pkgSuffix}.run";
          sha256 = sha256_32bit;
        }
      else throw "nvidia-x11 does not support platform ${stdenv.hostPlatform.system}";

    patches = if libsOnly then null else patches;
    inherit prePatch;
    inherit version useGLVND useProfiles;
    inherit (stdenv.hostPlatform) system;
    inherit i686bundled;

    outputs = [ "out" ]
        ++ lib.optional i686bundled "lib32"
        ++ lib.optional (!libsOnly) "bin"
        ++ lib.optional (!libsOnly && firmware) "firmware";
    outputDev = if libsOnly then null else "bin";

    kernel = if libsOnly then null else kernel.dev;
    kernelVersion = if libsOnly then null else kernel.modDirVersion;

    makeFlags = lib.optionals (!libsOnly) (kernel.makeFlags ++ [
      "IGNORE_PREEMPT_RT_PRESENCE=1"
      "NV_BUILD_SUPPORTS_HMM=1"
      "SYSSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
      "SYSOUT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    ]);

    hardeningDisable = [ "pic" "format" ];

    dontStrip = true;
    dontPatchELF = true;

    libPath = libPathFor pkgs;
    libPath32 = lib.optionalString i686bundled (libPathFor pkgsi686Linux);

    buildInputs = [ which ];
    nativeBuildInputs = [ perl nukeReferences ]
      ++ lib.optionals (!libsOnly) kernel.moduleBuildDependencies;

    disallowedReferences = lib.optionals (!libsOnly) [ kernel.dev ];

    passthru = {
      open = lib.mapNullable (hash: callPackage ./open.nix {
        inherit hash;
        nvidia_x11 = self;
        broken = brokenOpen;
      }) openSha256;
      settings = (if settings32Bit then pkgsi686Linux.callPackage else callPackage) (import ./settings.nix self settingsSha256) {
        withGtk2 = preferGtk2;
        withGtk3 = !preferGtk2;
      };
      persistenced = lib.mapNullable (hash: callPackage (import ./persistenced.nix self hash) { }) persistencedSha256;
      inherit persistencedVersion settingsVersion;
      compressFirmware = false;
    } // lib.optionalAttrs (!i686bundled) {
      inherit lib32;
    };

    meta = with lib; {
      homepage = "https://www.nvidia.com/object/unix.html";
      description = "X.org driver and kernel module for NVIDIA graphics cards";
      license = licenses.unfreeRedistributable;
      platforms = [ "x86_64-linux" ] ++ optionals (!i686bundled) [ "i686-linux" ];
      maintainers = with maintainers; [ jonringer ];
      priority = 4; # resolves collision with xorg-server's "lib/xorg/modules/extensions/libglx.so"
      # proprietary driver currently does not support X86_KERNEL_IBT, which is scheduled to be added in linux 6.2
      broken = broken || (kernel != null && kernel.kernelAtLeast "6.2");
    };
  };

in self
