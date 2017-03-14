{ version
, sha256_32bit
, sha256_64bit
, settingsSha256
, persistencedSha256
, useGLVND ? true
, useProfiles ? true
, preferGtk2 ? false
}:

{ stdenv, callPackage, callPackage_i686, buildEnv, fetchurl
, kernel ? null, xorg, zlib, perl, nukeReferences
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

assert (!libsOnly) -> kernel != null;

let
  nameSuffix = optionalString (!libsOnly) "-${kernel.version}";
  pkgSuffix = optionalString (versionOlder version "304") "-pkg0";

  self = stdenv.mkDerivation {
    name = "nvidia-x11-${version}${nameSuffix}";

    builder = ./builder.sh;

    src =
      if stdenv.system == "i686-linux" then
        fetchurl {
          url = "http://download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}${pkgSuffix}.run";
          sha256 = sha256_32bit;
        }
      else if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = "http://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}${pkgSuffix}.run";
          sha256 = sha256_64bit;
        }
      else throw "nvidia-x11 does not support platform ${stdenv.system}";

    # patch to get the nvidia and nvidiaBeta driver to compile on kernel 4.10
    patches = if versionOlder version "375"
              then null
              else [ (fetchurl {
                      url = https://git.archlinux.org/svntogit/packages.git/plain/trunk/kernel_4.10.patch?h=packages/nvidia;  sha256 = "0zhpx3baq2pca2pmz1af5cp2nzjxjx0j9w5xrdy204mnv3v2708z";
                     }) ];

    inherit version useGLVND useProfiles;
    inherit (stdenv) system;

    outputs = [ "out" ] ++ optional (!libsOnly) "bin";
    outputDev = if libsOnly then null else "bin";

    kernel = if libsOnly then null else kernel.dev;

    hardeningDisable = [ "pic" "format" ];

    dontStrip = true;
    dontPatchELF = true;

    libPath = makeLibraryPath [ xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib stdenv.cc.cc ];

    nativeBuildInputs = [ perl nukeReferences ];

    disallowedReferences = optional (!libsOnly) [ kernel.dev ];

    passthru = {
      settings = callPackage (import ./settings.nix self settingsSha256) {
        withGtk2 = preferGtk2;
        withGtk3 = !preferGtk2;
      };
      persistenced = if persistencedSha256 == null then null else callPackage (import ./persistenced.nix self persistencedSha256) { };
    };

    meta = with stdenv.lib; {
      homepage = http://www.nvidia.com/object/unix.html;
      description = "X.org driver and kernel module for NVIDIA graphics cards";
      license = licenses.unfreeRedistributable;
      platforms = platforms.linux;
      maintainers = [ maintainers.vcunat ];
      priority = 4; # resolves collision with xorg-server's "lib/xorg/modules/extensions/libglx.so"
    };
  };

in self
