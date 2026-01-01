{
  lib,
  mkDerivation,
  fetchFromGitHub,
  buildFreebsd,
  sys,
  withAmd ? true,
  withIntel ? true,
}:
mkDerivation rec {
<<<<<<< HEAD
  path = "...";
  pname =
    "drm-kmod-firmware" + lib.optionalString withAmd "-amd" + lib.optionalString withIntel "-intel";

  version = "20230625_4"; # there is a _8 but freebsd-ports is pinned to _4
=======
  pname =
    "drm-kmod-firmware" + lib.optionalString withAmd "-amd" + lib.optionalString withIntel "-intel";

  version = "20230625_8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "drm-kmod-firmware";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-RS8uXZMYoHfjDSC0OUJUU81eR8rLlEgFhuh+Y7+kXtA=";
  };

  outputs = [
    "out"
    "debug"
  ];

=======
    hash = "sha256-Ly9B0zf+YODel/X1sZYVVUVWh38faNLhkcXcjEnQwII=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  extraNativeBuildInputs = [ buildFreebsd.xargs-j ];

  hardeningDisable = [
    "pic" # generates relocations the linker can't handle
    "stackprotector" # generates stack protection for the function generating the stack canary
  ];

  # hardeningDisable = stackprotector doesn't seem to be enough, put it in cflags too
  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  KMODS =
    lib.optional withIntel "i915kmsfw"
    ++ lib.optionals withAmd [
      "amdgpukmsfw"
      "radeonkmsfw"
    ];

  env = sys.passthru.env;
  SYSDIR = "${sys.src}/sys";
<<<<<<< HEAD
  KERN_DEBUGDIR = "${builtins.placeholder "debug"}/lib/debug";
  KERN_DEBUGDIR_KODIR = "${KERN_DEBUGDIR}/kernel";
  KERN_DEBUGDIR_KMODDIR = "${KERN_DEBUGDIR}/kernel";

  KMODDIR = "${placeholder "out"}/kernel";

  makeFlags = [
    "DEBUG_FLAGS=-g"
  ];

=======

  KMODDIR = "${placeholder "out"}/kernel";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "GPU firmware for FreeBSD drm-kmod";
    platforms = lib.platforms.freebsd;
    license =
      lib.optional withAmd lib.licenses.unfreeRedistributableFirmware
      # Intel license prohibits modification. this will wrap firmware files in an ELF
      ++ lib.optional withIntel lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryFirmware ];
  };
}
