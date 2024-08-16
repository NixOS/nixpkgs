{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-apidoc";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ze/NkiEqX4I3FfuV7gmLRYprsJpe5hfZ7T3q2XF3zVU=";
  };

  postPatch = ''
    # break infite recursion, remove pytest 4 requirement
    rm test-requirements.txt requirements.txt
  '';

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension for running sphinx-apidoc on each build";
    homepage = "https://github.com/sphinx-contrib/apidoc";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
  };
}
