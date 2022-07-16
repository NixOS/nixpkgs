{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, jsonpatch
, jsonschema
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "warlock";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bcwaldon";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-HOCLzFYmOL/tCXT+NO/tCZuVXVowNEPP3g33ZYg4+6Q=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "jsonschema>=0.7,<4" "jsonschema"
    sed -i "/--cov/d" pytest.ini
  '';

  propagatedBuildInputs = [
    jsonpatch
    jsonschema
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/bcwaldon/warlock/issues/64
    "test_recursive_models"
  ];

  pythonImportsCheck = [
    "warlock"
  ];

  meta = with lib; {
    description = "Python object model built on JSON schema and JSON patch";
    homepage = "https://github.com/bcwaldon/warlock";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
