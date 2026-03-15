{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # meta
  music-assistant,
}:

buildPythonPackage (finalAttrs: {
  pname = "tunit";
  version = "1.7.2";
  pyproject = true;

  src = fetchPypi {
    pname = "tunit";
    inherit (finalAttrs) version;
    hash = "sha256-59UBnHlZBweJ675XrZ0EU9yO/k2Re2oDq2DU76aYR/Y=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
  ];

  pythonImportsCheck = [
    "tunit"
  ];

  meta = {
    description = "Time unit types. For transparency safety and readability.";
    homepage = "https://bitbucket.org/massultidev/tunit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fooker ];
  };
})
