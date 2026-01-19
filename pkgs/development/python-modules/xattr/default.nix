{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  cffi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pkyOIe/xvhQ6zPgP07j94+KKR4w32imHQq9kesPl4Kc=";
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

  meta = {
    description = "Python wrapper for extended filesystem attributes";
    mainProgram = "xattr";
    homepage = "https://github.com/xattr/xattr";
    changelog = "https://github.com/xattr/xattr/blob/v${version}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
