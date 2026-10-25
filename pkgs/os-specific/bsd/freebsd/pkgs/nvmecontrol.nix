{
  mkDerivation,
  libnvmf,
  libnv,
  libsbuf,
}:
mkDerivation {
  path = "sbin/nvmecontrol";
  extraPaths = [
    "sys/dev/nvme"
  ];
  outputs = [
    "out"
    "debug"
  ];
  buildInputs = [
    libnvmf
    libnv
    libsbuf
  ];

  MK_TESTS = "no";
}
