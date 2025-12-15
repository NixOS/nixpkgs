{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  mbstrdecoder,
  python-dateutil,
  pytz,
  packaging,
  pytestCheckHook,
  pythonOlder,
  tcolorpy,
}:

buildPythonPackage rec {
  pname = "typepy";
  version = "1.3.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "typepy";
    tag = "v${version}";
    hash = "sha256-lgwXoEtv2nBRKiWQH5bDrAIfikKN3cOqcHLEdnSAMpc=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ mbstrdecoder ];

  optional-dependencies = {
    datetime = [
      python-dateutil
      pytz
      packaging
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    tcolorpy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "typepy" ];

  meta = {
    description = "Library for variable type checker/validator/converter at a run time";
    homepage = "https://github.com/thombashi/typepy";
    changelog = "https://github.com/thombashi/typepy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genericnerdyusername ];
  };
}
