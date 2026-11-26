{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dbus-next,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "clipman";
  version = "3.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NikitaBeloglazov";
    repo = "clipman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m50yxbbMBLooVQD1QYQi6QekaiQlzTHXSJIMdU+/+Rw=";
  };

  buildInputs = [
    dbus-next
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [
    "clipman"
  ];

  # no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/NikitaBeloglazov/clipman";
    description = "Python3 module for working with clipboard";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ Freed-Wu ];
    platforms = lib.platforms.unix;
  };
})
