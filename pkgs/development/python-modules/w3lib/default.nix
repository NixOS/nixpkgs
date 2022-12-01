{ lib
, buildPythonPackage
, fetchPypi
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E98V+MF7Fj3g/V+qiSwa0UPhkN/L25hTS7l16zfGx9Y=";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "w3lib" ];

  disabledTests = [
    "test_add_or_replace_parameter"
  ];

  meta = with lib; {
    description = "A library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
