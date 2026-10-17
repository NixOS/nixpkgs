{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "trueskill";
  version = "0.4.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "trueskill";
    inherit (finalAttrs) version;
    hash = "sha256-nWK0jSQoNp1xK9m+z/n5osqjJeGiq1+TktNL/3V4Z7s=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  # Can't build distribute, see https://github.com/NixOS/nixpkgs/pull/49340
  doCheck = false;

  pythonImportsCheck = [ "trueskill" ];

  meta = {
    description = "Video game rating system";
    homepage = "https://trueskill.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eadwu ];
  };
})
