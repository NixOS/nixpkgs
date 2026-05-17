{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linux,
  meson,
  ninja,
  pkg-config,
  runtimeShell,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fus3";
  version = "3.18.2";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "libfuse";
    tag = "fuse-${finalAttrs.version}";
    hash = "sha256-QArQMSStVxwUo6CgU2JlXBdFWjzlGXfZk1AVGLGeE70=";

  };

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  patches = [
    ./fuse3-install.patch
    ./fuse3-Do-not-set-FUSERMOUNT_DIR.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMusl) [ udevCheckHook ] # inf rec on musl, so skip
  ;

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
    "udev"
  ];

  mesonFlags = [
    "-Dudevrulesdir=/udev/rules.d"
    "-Duseroot=false"
    "-Dinitscriptdir="
    "-Dexamples=false" # examples fail on musl and are just generally useless
  ];

  # Ensure that FUSE calls the setuid wrapper, not
  # $out/bin/fusermount. It falls back to calling fusermount in
  # $PATH, so it should also work on non-NixOS systems.
  env.NIX_CFLAGS_COMPILE = ''-DFUSERMOUNT_DIR="/run/wrappers/bin"'';

  preConfigure = ''
    substituteInPlace lib/mount_util.c \
      --replace-fail "/bin/mount" "${lib.getBin util-linux}/bin/mount" \
      --replace-fail "/bin/umount" "${lib.getBin util-linux}/bin/umount"
    substituteInPlace util/mount.fuse.c \
      --replace-fail "/bin/sh" "${runtimeShell}"
  '';
  # v2: no tests, v3: all tests get skipped in a sandbox
  doCheck = false;
  doInstallCheck = true;

  # Drop `/etc/fuse.conf` because it is a no-op config and
  # would conflict with our fuse module.
  postInstall = ''
    rm $out/etc/fuse.conf
    mkdir $udev
    mv $out/etc $udev
  '';

  # Don't pull in SUID `fusermount{,3}` binaries into development environment.
  propagatedBuildOutputs = [ "out" ];

  meta = {
    description = "Library that allows filesystems to be implemented in user space";
    longDescription = ''
      FUSE (Filesystem in Userspace) is an interface for userspace programs to
      export a filesystem to the Linux kernel. The FUSE project consists of two
      components: The fuse kernel module (maintained in the regular kernel
      repositories) and the libfuse userspace library (this package). libfuse
      provides the reference implementation for communicating with the FUSE
      kernel module.
    '';
    homepage = "https://github.com/libfuse/libfuse";
    changelog = "https://github.com/libfuse/libfuse/releases/tag/fuse-${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [
      oxalica
      jackr
    ];
    outputsToInstall = [ "bin" ];
  };
})
