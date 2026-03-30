{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "w3lib";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "w3lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RcjsuzlHx3vp0tBucCQZQTVq9FsxSpY9iLwlvoo02cE=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "w3lib" ];

  meta = {
    description = "Library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    changelog = "https://github.com/scrapy/w3lib/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
