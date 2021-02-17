{ lib
, buildPythonPackage
, fetchPypi
, six
, typing-extensions
, requests
, yarl
}:

buildPythonPackage rec {
  pname = "transmission-rpc";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y5048109j6z4smzwysvdjfn6cj9698dsxfim9i4nqam4nmw2wi7";
  };

  propagatedBuildInputs = [
    six
    typing-extensions
    requests
    yarl
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "transmission_rpc" ];

  meta = with lib; {
    description = "Python module that implements the Transmission bittorent client RPC protocol";
    homepage = "https://pypi.python.org/project/transmission-rpc/";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
