{ version
, sha256_32bit
, sha256_64bit
, settingsSha256
, persistencedSha256
, useGLVND ? true
, useProfiles ? true
, preferGtk2 ? false
}:

{ stdenv, callPackage, callPackage_i686, buildEnv, fetchurl, fetchpatch
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
          url = "https://download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}${pkgSuffix}.run";
          sha256 = sha256_32bit;
        }
      else if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}${pkgSuffix}.run";
          sha256 = sha256_64bit;
        }
      else throw "nvidia-x11 does not support platform ${stdenv.system}";

    prePatch = let
      debPatches = fetchurl {
        url = "mirror://debian/pool/non-free/n/nvidia-graphics-drivers-legacy-304xx/"
            + "nvidia-graphics-drivers-legacy-304xx_304.135-2.debian.tar.xz";
        sha256 = "0mhji0ssn7075q5a650idigs48kzf11pzj2ca2n07rwxg3vj6pdr";
      };
      prefix = "debian/module/debian/patches";
      applyPatches = pnames: if pnames == [] then null else
        ''
          tar xf '${debPatches}'
          sed 's|^\([+-]\{3\} [ab]\)/|\1/kernel/|' -i ${prefix}/*.patch
          patches="$patches ${concatMapStringsSep " " (pname: "${prefix}/${pname}.patch") pnames}"
        '';
    in
      # TODO: perhaps other branches also need patching?
      if (versionOlder version "340") then applyPatches
        [ "fix-typos" "drm-driver-legacy" "deprecated-cpu-events" "disable-mtrr" ]
      else null;

    # patch to get the nvidia and nvidiaBeta driver to compile on kernel 4.10
    patches = if libsOnly
              then null
              else if versionOlder version "340"
              then null
              else if versionOlder version "375"
              then [
                     (fetchpatch {
                        name = "kernel-4.10.patch";
                        url = https://git.archlinux.org/svntogit/packages.git/plain/nvidia-340xx/trunk/4.10.0_kernel.patch?id=53fb1df89;
                        sha256 = "171hb57m968qdjcr3h8ppfzhrchf573f39rdja86a1qq1gmrv7pa";
                     })
                         # from https://git.archlinux.org/svntogit/packages.git/plain/trunk/fs52243.patch?h=packages/nvidia-340xx
                         # with datestamps removed
                     ./fs52243.patch
                   ]
              else null;

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
