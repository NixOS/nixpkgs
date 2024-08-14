{
  mkKdeDerivation,
  alsa-lib,
}:
mkKdeDerivation {
  pname = "libkcompactdisc";

  extraBuildInputs = [alsa-lib];
}
