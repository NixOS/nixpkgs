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

buildPythonPackage (finalAttrs: {
  pname = "zdaemon";
  version = "5.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "zdaemon";
    inherit (finalAttrs) version;
    hash = "sha256-8GwsfK9RnHYINPj+JuVzWVDVAX9y1cII3IsZABQFlM0=";
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

  unittestFlags = [ "--start-directory=src/zdaemon/tests" ];

  meta = {
    description = "Daemon process control library and tools for Unix-based systems";
    mainProgram = "zdaemon";
    homepage = "https://github.com/zopefoundation/zdaemon";
    changelog = "https://github.com/zopefoundation/zdaemon/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
    broken = true;
  };
})
