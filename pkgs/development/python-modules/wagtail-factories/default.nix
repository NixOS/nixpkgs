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
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "wagtail-factories";
    owner = "wagtail";
    tag = "v${version}";
    hash = "sha256-IPUnRFsl2qzcuX2FNqQ1xBY7ou7CBWRhIfS/TmUGrpc=";
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

  meta = {
    description = "Factory boy classes for wagtail";
    homepage = "https://github.com/wagtail/wagtail-factories";
    changelog = "https://github.com/wagtail/wagtail-factories/blob/${src.tag}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
