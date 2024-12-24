{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "six";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benjaminp";
    repo = "six";
    rev = "refs/tags/${version}";
    hash = "sha256-tz99C+dz5xJhunoC45bl0NdSdV9NXWya9ti48Z/KaHY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray =
    if isPyPy then
      [
        # uses ctypes to find native library
        "--deselect=test_six.py::test_move_items"
      ]
    else
      null;

  pythonImportsCheck = [ "six" ];

  meta = {
    changelog = "https://github.com/benjaminp/six/blob/${version}/CHANGES";
    description = "Python 2 and 3 compatibility library";
    homepage = "https://github.com/benjaminp/six";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
