{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "tsv";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamnovak";
    repo = "tsv";
    rev = "379189e9da4c1b65d0587bb32f3b51e6a7c936c8"; # No Git Tags
    hash = "sha256-Axs597Ir7h4mB07Vfy3Xiqwag2rimqBAnodPrO1Lxa4=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "tsv" ];

  meta = {
    description = "Tab-Separated Value IO Library";
    homepage = "https://github.com/adamnovak/tsv";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
