{
  lib,
  buildPythonPackage,
  callPackage,
  factory-boy,
  fetchFromGitHub,
  setuptools,
  wagtail,
}:

buildPythonPackage rec {
  pname = "wagtail-factories";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "wagtail-factories";
    owner = "wagtail";
    tag = "v${version}";
    hash = "sha256-Rbu8D0vmUyF76YzF1QSQC5c0s12GxRrHNuUhMxcZdQY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    factory-boy
    wagtail
  ];

  # Tests require wagtail which in turn requires wagtail-factories
  # Note that pythonImportsCheck is not used because it requires a Django app
  doCheck = false;

  passthru.tests.wagtail-factories = callPackage ./tests.nix { };

  meta = with lib; {
    description = "Factory boy classes for wagtail";
    homepage = "https://github.com/wagtail/wagtail-factories";
    changelog = "https://github.com/wagtail/wagtail-factories/blob/${src.tag}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
