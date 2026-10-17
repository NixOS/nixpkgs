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
  tcolorpy,
}:

buildPythonPackage rec {
  pname = "typepy";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "typepy";
    tag = "v${version}";
    hash = "sha256-QzfzAWQjKQBIVkgH+dPVVhlk717R71DiOhXZyfooJus=";
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
    maintainers = [ ];
  };
}
