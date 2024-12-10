{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  cachetools,
}:

buildHomeAssistantComponent rec {
  owner = "dckiller51";
  domain = "bodymiscale";
  version = "2024.6.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = version;
    hash = "sha256-6bYKqU9yucISjTrmCUx1bNn9kqvT9jW1OBrqAa4ayEQ=";
  };

  postPatch = ''
    substituteInPlace custom_components/bodymiscale/manifest.json --replace-fail 'cachetools==5.3.0' 'cachetools>=5.3.0'
  '';

  propagatedBuildInputs = [
    cachetools
  ];

  meta = {
    description = "Home Assistant custom component providing body metrics for Xiaomi Mi Scale 1 and 2";
    homepage = "https://github.com/dckiller51/bodymiscale";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ justinas ];
  };
}
