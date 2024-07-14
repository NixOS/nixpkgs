{
  buildPythonPackage,
  lib,
  python,
  fetchPypi,
  msrest,
}:

buildPythonPackage rec {
  version = "0.1.25";
  format = "setuptools";
  pname = "vsts";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2heRYBIfWzi+Bh2/8pzStg1dApsiBxAkVNd6cRTmT5c=";
  };

  propagatedBuildInputs = [ msrest ];

  postPatch = ''
    substituteInPlace setup.py --replace "msrest>=0.6.0,<0.7.0" "msrest"
  '';

  # Tests are highly impure
  checkPhase = ''
    ${python.interpreter} -c 'import vsts.version; print(vsts.version.VERSION)'
  '';

  meta = with lib; {
    description = "Python APIs for interacting with and managing Azure DevOps";
    homepage = "https://github.com/microsoft/azure-devops-python-api";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
