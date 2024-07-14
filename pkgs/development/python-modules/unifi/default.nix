{
  lib,
  buildPythonPackage,
  fetchPypi,
  urllib3,
}:

buildPythonPackage rec {
  pname = "unifi";
  version = "1.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SLev9CnpBn2gqNgAyE7xH+94qo25v69yvonoDwPoL18=";
  };

  propagatedBuildInputs = [ urllib3 ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "API towards the Ubiquity Networks UniFi controller";
    homepage = "https://pypi.python.org/pypi/unifi/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
