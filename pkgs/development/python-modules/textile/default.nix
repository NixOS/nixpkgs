{ lib
, buildPythonPackage
, fetchFromGitHub
, html5lib
, pytestCheckHook
, pythonOlder
, regex
}:

buildPythonPackage rec {
  pname = "textile";
  version = "4.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-textile";
    rev = version;
    hash = "sha256-WwX7h07Bq8sNsViHwmfhrrqleXacmrIY4ZBBaP2kKnI=";
  };

  propagatedBuildInputs = [
    html5lib
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov=textile --cov-report=html --cov-append --cov-report=term-missing" ""
  '';

  pythonImportsCheck = [
    "textile"
  ];

  meta = with lib; {
    description = "MOdule for generating web text";
    homepage = "https://github.com/textile/python-textile";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
