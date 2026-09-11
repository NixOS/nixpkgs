{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # optionals
  genshi,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  webtest,
}:

buildPythonPackage (finalAttrs: {
  pname = "static3";
  version = "0.7.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rmohr";
    repo = "static3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uFgv+57/UZs4KoOdkFxbvTEDQrJbb0iYJ5JoWWN4yFY=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    KidMagic = [
      # TODO: kid
    ];
    Genshimagic = [ genshi ];
  };

  pythonImportsCheck = [ "static" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    webtest
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    changelog = "https://github.com/rmohr/static3/releases/tag/${finalAttrs.src.tag}";
    description = "Really simple WSGI way to serve static (or mixed) content";
    mainProgram = "static";
    homepage = "https://github.com/rmohr/static3";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
