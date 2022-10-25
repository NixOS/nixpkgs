{ lib
, fetchPypi
, buildPythonPackage
, zope-interface
, mock
}:


buildPythonPackage rec {
  pname = "transaction";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c15ef0b7ff3518357ceea75722a30d974c3f85e11aa5cec5d5a2b6a40cfcf68";
  };

  propagatedBuildInputs = [ zope-interface mock ];

  meta = with lib; {
    description = "Transaction management";
    homepage = "https://pypi.python.org/pypi/transaction";
    license = licenses.zpl20;
  };
}
