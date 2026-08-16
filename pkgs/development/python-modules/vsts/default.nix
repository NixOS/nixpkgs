{
  buildPythonPackage,
  lib,
  python,
  fetchPypi,
  setuptools,
  msrest,
}:

buildPythonPackage (finalAttrs: {
  pname = "vsts";
  version = "0.1.25";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2heRYBIfWzi+Bh2/8pzStg1dApsiBxAkVNd6cRTmT5c=";
  };

  build-system = [ setuptools ];

  dependencies = [ msrest ];

  postPatch = ''
    substituteInPlace setup.py --replace-fail "msrest>=0.6.0,<0.7.0" "msrest"
  '';

  # Tests are highly impure
  checkPhase = ''
    ${python.interpreter} -c 'import vsts.version; print(vsts.version.VERSION)'
  '';

  pythonImportsCheck = [ "vsts" ];

  meta = {
    description = "Python APIs for interacting with and managing Azure DevOps";
    homepage = "https://github.com/microsoft/azure-devops-python-api";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
