{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  cffi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/svzsFBD7TSHooGQ3sPkxNh5svzsDjC6/Y7F1LYENjA=";
  };

  nativeBuildInputs = [
    cffi
    setuptools
  ];

  # https://github.com/xattr/xattr/issues/43
  doCheck = false;

  propagatedBuildInputs = [ cffi ];

  postBuild = ''
    ${python.pythonOnBuildForHost.interpreter} -m compileall -f xattr
  '';

  pythonImportsCheck = [ "xattr" ];

  meta = with lib; {
    description = "Python wrapper for extended filesystem attributes";
    mainProgram = "xattr";
    homepage = "https://github.com/xattr/xattr";
    changelog = "https://github.com/xattr/xattr/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
