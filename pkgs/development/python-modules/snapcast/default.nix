{ stdenv, buildPythonPackage, fetchPypi, isPy3k, pytest
, construct }:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.0.9";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hlfcg0qdfavjzhxz4v2spjkj6440a1254wrncfkfkyff6rv9x3s";
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
