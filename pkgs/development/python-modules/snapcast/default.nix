{ stdenv, buildPythonPackage, fetchPypi, isPy3k, pytest
, construct }:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.0.10";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a862a57ca65aa11cf010a19cdfee37e5728d486ee92684b00233442613b5120";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ construct ];

  # no checks from Pypi - https://github.com/happyleavesaoc/python-snapcast/issues/23
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = https://github.com/happyleavesaoc/python-snapcast/;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
