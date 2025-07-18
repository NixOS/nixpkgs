{
  mkKdeDerivation,
  qtwebchannel,
  qtwebengine,
  qttools,
  libpcap,
  libnl,
  lm_sensors,
}:
mkKdeDerivation {
  pname = "libksysguard";

  patches = [
    ./helper-path.patch
  ];

  extraBuildInputs = [
    qtwebchannel
    qtwebengine
    qttools
    libpcap
    libnl
    lm_sensors
  ];
}
