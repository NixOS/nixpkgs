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

  extraBuildInputs = [qtwebchannel qtwebengine qttools libpcap libnl lm_sensors];
}
