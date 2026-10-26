{
  lib,
  buildPythonPackage,
  callPackage,
  factory-boy,
  fetchFromGitHub,
  setuptools,
  wagtail,
}:

buildPythonPackage (finalAttrs: {
  pname = "wagtail-factories";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "wagtail-factories";
    owner = "wagtail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mVxLnP++j116bfJMJa7GoH1Rqvj7rdj0JsNFm7fJ7h0=";
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
    changelog = "https://github.com/wagtail/wagtail-factories/blob/${finalAttrs.src.tag}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
})
