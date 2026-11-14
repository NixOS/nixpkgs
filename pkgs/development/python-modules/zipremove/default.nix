{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "zipremove";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-PFlXwRVEe1QpnTojEodktZxFWPyYxLh4/y28XbimICE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # zipremove supports Python 3.7 and newer.
  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "zipremove" ];

  meta = {
    description = "Extend zipfile with remove-related capabilities";
    homepage = "https://github.com/danny0838/zipremove";
    license = lib.licenses.mit;
  };
})
