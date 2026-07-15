{
  mkDerivation,
}:
mkDerivation {
  path = "lib/libc";
  extraPaths = [
    "lib/libc_nonshared"
    "lib/libsys"
    "sys/sys"
  ];

  postPatch = ''
    sed -E -i -e '/afterinstallconfig/d' -e '/master.passwd/d' "lib/libc/gen/Makefile.inc"
  '';

  dontBuild = true;
  installTargets = [ "installconfig" ];
  MK_TESTS = "no";
}
