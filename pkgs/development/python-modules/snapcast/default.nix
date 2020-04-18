{ stdenv, buildPythonPackage, fetchPypi, isPy3k, pytest
, construct }:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z3c9p22pm3823jzh917c3rryv02mhigrjkjf9wlhzmjwx5vmjqf";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ construct ];

  # no checks from Pypi - https://github.com/happyleavesaoc/python-snapcast/issues/23
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = "https://github.com/happyleavesaoc/python-snapcast/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
