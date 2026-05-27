{
  lib,
  buildPythonPackage,
  fetchPypi,

  hatchling,
  pillow,
}:

buildPythonPackage (finalAttrs: {
  pname = "thumbhash";
  version = "0.1.2";
  pyproject = true;

  # the pyproject.toml of GitHub release "v0.1.2" uses "thumbhash-py"
  # for the project name and does not build.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-705jmPk/O1rUgNyOOjs6IAgTyGqIV/sGn4R4voCfgkc=";
  };

  build-system = [ hatchling ];

  optional-dependencies = [ pillow ];

  meta = {
    description = "Python port of thumbhash, a representation of an image placeholder";
    homepage = "https://github.com/justinforlenza/thumbhash-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haansn08 ];
  };
})
