{ stdenv, buildPythonPackage, fetchPypi
, pytest, heapdict }:

buildPythonPackage rec {
  pname = "zict";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12h95vbkbar1hc6cr1kpr6zr486grj3mpx4lznvmnai0iy6pbqp4";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ heapdict ];

  meta = with stdenv.lib; {
    description = "Mutable mapping tools.";
    homepage = https://github.com/dask/zict;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
