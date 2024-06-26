{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtpositioning,
}:
mkKdeDerivation rec {
  pname = "kweathercore";
  version = "0.8.0";

  src = fetchurl {
    url = "mirror://kde/stable/kweathercore/${version}/kweathercore-${version}.tar.xz";
    hash = "sha256-m8rBPa+YcF4vDVsGshoahpSWIHj84b9iDbvDZIc6Dv4=";
  };

  extraBuildInputs = [qtpositioning];

  meta.license = with lib.licenses; [cc-by-40 cc0 lgpl2Plus];
}
