{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zconfig,
  manuel,
  unittestCheckHook,
  zope-testing,
}:

buildPythonPackage rec {
  pname = "zdaemon";
  version = "5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Iun+UFDq67ngPZrWTk9jzNheBMOP2zUc8RO+9vaNt6Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ zconfig ];

  pythonImportsCheck = [ "zdaemon" ];

  # require zc-customdoctests but it is not packaged
  doCheck = false;

  nativeCheckInputs = [
    manuel
    unittestCheckHook
    # zc-customdoctests
    zope-testing
  ];

  unittestFlagsArray = [ "src/zdaemon/tests" ];

  meta = {
    description = "Daemon process control library and tools for Unix-based systems";
    mainProgram = "zdaemon";
    homepage = "https://github.com/zopefoundation/zdaemon";
    changelog = "https://github.com/zopefoundation/zdaemon/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
