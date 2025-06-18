{
  mkDerivation,
}:
mkDerivation {
  path = "sbin/sysctl";
  patches = [ ./no-perms.patch ];
  meta.mainProgram = "sysctl";
}
