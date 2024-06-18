{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sexpdata";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-krZ7A2H2dm+PnkS5UZzz+8+vp1Xbhbv4k8Phz03awQk=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "sexpdata" ];

  meta = with lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/jd-boyd/sexpdata";
    changelog = "https://github.com/jd-boyd/sexpdata/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
