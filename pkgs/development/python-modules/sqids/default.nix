{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqids";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WsCPDFybaBS8Lnx57lkx4ISdJdlcUOQVdxsCKkT1ivk=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqids" ];

  meta = with lib; {
    homepage = "https://sqids.org/python";
    description = "Library that lets you generate short YouTube-looking IDs from numbers";
    license = with licenses; mit;
    maintainers = with maintainers; [ panicgh ];
  };
}
