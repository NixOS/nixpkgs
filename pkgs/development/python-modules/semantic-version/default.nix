{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "semantic-version";
  version = "2.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "semantic_version";
    inherit version;
    sha256 = "sha256-q/VIc1U+Xgem/U1fZTt4H1rkEpekk2ZrWdzyFABqErI=";
  };

  pythonImportsCheck = [
    "semantic_version"
  ];

  # ModuleNotFoundError: No module named 'tests'
  doCheck = false;

  meta = with lib; {
    description = "A library implementing the 'SemVer' scheme";
    homepage = "https://github.com/rbarrois/python-semanticversion/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ layus makefu ];
  };
}
