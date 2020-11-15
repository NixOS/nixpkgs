{ version
, sha256_32bit ? null
, sha256_64bit
, settingsSha256
, persistencedSha256
, useGLVND ? true
, useProfiles ? true
, preferGtk2 ? false
, settings32Bit ? false

, prePatch ? ""
, patches ? []
, broken ? false
}:

{ stdenv, callPackage, pkgs, pkgsi686Linux, fetchurl
, kernel ? null, perl, nukeReferences
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

assert !libsOnly -> kernel != null;
assert versionOlder version "391" -> sha256_32bit != null;
assert ! versionOlder version "391" -> stdenv.hostPlatform.system == "x86_64-linux";

let
  nameSuffix = optionalString (!libsOnly) "-${kernel.version}";
  pkgSuffix = optionalString (versionOlder version "304") "-pkg0";
  i686bundled = versionAtLeast version "391";

  libPathFor = pkgs: pkgs.lib.makeLibraryPath [ pkgs.libdrm pkgs.xorg.libXext pkgs.xorg.libX11
    pkgs.xorg.libXv pkgs.xorg.libXrandr pkgs.xorg.libxcb pkgs.zlib pkgs.stdenv.cc.cc ];

  self = stdenv.mkDerivation {
    name = "nvidia-x11-${version}${nameSuffix}";

    builder = ./builder.sh;

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}${pkgSuffix}.run";
          sha256 = sha256_64bit;
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        fetchurl {
          url = "https://download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}${pkgSuffix}.run";
          sha256 = sha256_32bit;
        }
      else throw "nvidia-x11 does not support platform ${stdenv.hostPlatform.system}";

    patches = if libsOnly then null else patches;
    inherit prePatch;
    inherit version useGLVND useProfiles;
    inherit (stdenv.hostPlatform) system;
    inherit i686bundled;

    outputs = [ "out" ]
        ++ optional i686bundled "lib32"
        ++ optional (!libsOnly) "bin";
    outputDev = if libsOnly then null else "bin";

    kernel = if libsOnly then null else kernel.dev;
    kernelVersion = if libsOnly then null else kernel.modDirVersion;

    hardeningDisable = [ "pic" "format" ];

    dontStrip = true;
    dontPatchELF = true;

    libPath = libPathFor pkgs;
    libPath32 = optionalString i686bundled (libPathFor pkgsi686Linux);

    nativeBuildInputs = [ perl nukeReferences ]
      ++ optionals (!libsOnly) kernel.moduleBuildDependencies;

    disallowedReferences = optional (!libsOnly) [ kernel.dev ];

    passthru = {
      settings = (if settings32Bit then pkgsi686Linux.callPackage else callPackage) (import ./settings.nix self settingsSha256) {
        withGtk2 = preferGtk2;
        withGtk3 = !preferGtk2;
      };
      persistenced = mapNullable (hash: callPackage (import ./persistenced.nix self hash) { }) persistencedSha256;
    };

    meta = with stdenv.lib; {
      homepage = "https://www.nvidia.com/object/unix.html";
      description = "X.org driver and kernel module for NVIDIA graphics cards";
      license = licenses.unfreeRedistributable;
      platforms = [ "x86_64-linux" ] ++ optionals (!i686bundled) [ "i686-linux" ];
      maintainers = with maintainers; [ baracoder ];
      priority = 4; # resolves collision with xorg-server's "lib/xorg/modules/extensions/libglx.so"
      inherit broken;
    };
  };

in self
