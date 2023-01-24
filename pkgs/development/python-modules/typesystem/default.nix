{ lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "typesystem";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    hash = "sha256-fjnheHWjIDbJY1iXCRKCpqTCwtUWK9YXbynRCZquQ7c=";
  };

  propagatedBuildInputs = [
    jinja2
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "typesystem"
  ];

  meta = with lib; {
    description = "A type system library for Python";
    homepage = "https://github.com/encode/typesystem";
    license = licenses.bsd3;
    maintainers =  with maintainers; [ costrouc ];
  };
}
