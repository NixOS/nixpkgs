{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  ipython,
  pandas,
  plotly,
  requests,
  tqdm,
  unidecode,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "tcia-utils";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kirbyju";
    repo = "tcia_utils";
    rev = "9ff8a409df9daaa3f9bc28f0a951d7f6fcb90160"; # Corresponds to v3.2.1
    hash = "sha256-IW6rxlmRj7RW3hM7aZR+BuqboDzp+2R2ObGwAhOxMPM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    beautifulsoup4
    ipython
    pandas
    plotly
    requests
    tqdm
    unidecode
  ];

  pythonRemoveDeps = [ "bs4" ];

  # Tests require network access to TCIA API and specific credentials
  doCheck = false;

  pythonImportsCheck = [ "tcia_utils" ];

  meta = {
    description = "Python utilities for interacting with The Cancer Imaging Archive (TCIA)";
    homepage = "https://github.com/kirbyju/tcia_utils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sgomezsal ];
  };
})
