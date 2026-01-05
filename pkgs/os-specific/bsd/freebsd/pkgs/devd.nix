{
  lib,
  mkDerivation,
  libutil,
  flex,
  byacc,
}:
mkDerivation {
  path = "sbin/devd";

  outputs = [
    "out"
    "etc"
    "man"
    "debug"
  ];

  buildInputs = [
    libutil
  ];

  extraNativeBuildInputs = [
    flex
    byacc
  ];

  clangFixup = false;

  MK_TESTS = "no";
  MK_AUTOFS = "yes";
  MK_BLUETOOTH = "yes";
  MK_HYPERV = "yes";
  MK_USB = "yes";
  MK_ZFS = "yes";

  postPatch = ''
    substituteInPlace $BSDSRCDIR/sbin/devd/Makefile --replace-fail /etc $etc/etc
  '';

  NIX_CFLAGS_COMPILE = [
    "-Wno-c++20-extensions"
    "-Wno-nullability-completeness"
  ];

  postInstall = ''
    make $makeFlags installconfig
  '';

  meta.platforms = lib.platforms.freebsd;
  meta.mainProgram = "devd";
}
