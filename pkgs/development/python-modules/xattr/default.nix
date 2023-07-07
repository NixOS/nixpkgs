{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "0.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wS59gf+qBgWzrIwiwplKjhipzxxZKHobdyKiKJyVLsU=";
  };

  propagatedBuildInputs = [
    cffi
  ];

  # https://github.com/xattr/xattr/issues/43
  doCheck = false;

  postBuild = ''
    ${python.pythonForBuild.interpreter} -m compileall -f xattr
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
