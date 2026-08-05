{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  cffi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "xattr";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-MEOfq9feB4eyfppuHVacWVmFTLMi9kznOA/tv6UDUDY=";
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
    changelog = "https://github.com/xattr/xattr/blob/v${finalAttrs.version}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
