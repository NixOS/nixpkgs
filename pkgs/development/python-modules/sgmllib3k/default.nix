{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "sgmllib3k";
  version = "1.0.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eGj7HIv6dkwaxWPTzzacOB0TJdNhJJM6cm8p/NqoEuk=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    "test_declaration_junk_chars"
  ];

  doCheck = false;

  pythonImportsCheck = [
    "sgmllib"
  ];

  meta = with lib; {
    homepage = "https://pypi.org/project/sgmllib3k/";
    description = "Python 3 port of sgmllib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
