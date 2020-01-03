{ stdenv, fetchPypi, buildPythonPackage, nose, numpy }:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07kahmr0vfmncf8y4x6ldjrghnd4gsf0fwykgjj5ijvqi9xc21xs";
  };

  buildInputs = [ nose numpy ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pythonhosted.org/uncertainties/;
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with maintainers; [ rnhmjoj ];
    license = licenses.bsd3;
  };
}
