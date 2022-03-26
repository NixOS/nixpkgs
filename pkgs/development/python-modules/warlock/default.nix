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
  version = "1.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bcwaldon";
    repo = pname;
    rev = version;
    hash = "sha256-59V4KOwjs/vhA3F3E0j3p5L4JnKPgcExN+mgSWs0Cn0=";
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
