{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  jsonpatch,
  jsonschema,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "warlock";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bcwaldon";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-HOCLzFYmOL/tCXT+NO/tCZuVXVowNEPP3g33ZYg4+6Q=";
  };

  postPatch = ''
    sed -i '/--cov/d' pytest.ini
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    jsonpatch
    jsonschema
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/bcwaldon/warlock/issues/64
    "test_recursive_models"
  ];

  pythonImportsCheck = [ "warlock" ];

  meta = with lib; {
    description = "Python object model built on JSON schema and JSON patch";
    homepage = "https://github.com/bcwaldon/warlock";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
