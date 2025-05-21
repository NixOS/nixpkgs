{
  mkDerivation,
  byacc,
}:
mkDerivation {
  path = "sbin/pfctl";
  extraPaths = [
    "sys/net"
  ];

  extraNativeBuildInputs = [
    byacc
  ];

  meta.mainProgram = "pfctl";
}
