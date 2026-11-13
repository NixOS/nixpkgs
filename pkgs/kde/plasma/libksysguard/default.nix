{
  mkKdeDerivation,
  qttools,
  kitemmodels,
  kquickcharts,
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
    qttools
    libpcap
    libnl
    lm_sensors
  ];

  extraPropagatedBuildInputs = [
    kitemmodels
    kquickcharts
  ];
}
