{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbr,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-apidoc";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "apidoc";
    tag = finalAttrs.version;
    hash = "sha256-zJmthFeeLsEkVPiFO/42AEhfCj+e85v8nNRd6v7SlZI=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

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

  meta = {
    description = "Sphinx extension for running sphinx-apidoc on each build";
    homepage = "https://github.com/sphinx-contrib/apidoc";
    license = lib.licenses.bsd2;
    teams = [ lib.teams.openstack ];
  };
})
