{
  mkDerivation,
  flex,
  byacc,
}:
mkDerivation {
  path = "usr.sbin/acpi";
  extraPaths = [ "sys/contrib/dev/acpica" ];
  extraNativeBuildInputs = [
    flex
    byacc
  ];
}
