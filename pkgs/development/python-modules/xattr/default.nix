{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-osfLLvRBv2eeJAtl4gXwij7jFeGQ/qVnPmD9aBLmNKU=";
  };

  propagatedBuildInputs = [
    cffi
  ];

  # https://github.com/xattr/xattr/issues/43
  doCheck = false;

  postBuild = ''
    ${python.pythonOnBuildForHost.interpreter} -m compileall -f xattr
  '';

  pythonImportsCheck = [
    "xattr"
  ];

  meta = with lib; {
    description = "Python wrapper for extended filesystem attributes";
    homepage = "https://github.com/xattr/xattr";
    changelog = "https://github.com/xattr/xattr/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
