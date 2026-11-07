{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "w3lib";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "w3lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FaH3NrQ1qAH3tJbIiAVeJXxiTjF7861kl3U5Ux3HrlU=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "w3lib" ];

  meta = {
    description = "Library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    changelog = "https://github.com/scrapy/w3lib/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
