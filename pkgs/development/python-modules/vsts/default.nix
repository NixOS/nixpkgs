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
    sha256 = "15sgwqa72ynpahj101r2kc15s3dnsafg5gqx0sz3hnqz29h925ys";
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
    maintainers = with maintainers; [ jonringer ];
  };
}
