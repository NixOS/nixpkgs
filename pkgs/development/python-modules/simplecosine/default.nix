{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simplecosine";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "simplecosine";
    tag = "v${version}";
    hash = "sha256-TNQnSbCh7o5JsxvfljRGSNwptwpLHmVw9gyk0TELDek=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "simplecosine"
  ];

  meta = {
    description = "Simple cosine distance calculation for string comparison";
    homepage = "https://github.com/dedupeio/simplecosine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
