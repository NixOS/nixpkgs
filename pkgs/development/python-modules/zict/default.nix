{ stdenv, buildPythonPackage, fetchPypi
, pytest, heapdict }:

buildPythonPackage rec {
  pname = "zict";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63377f063086fc92e5c16e4d02162c571f6470b9e796cf3411ef9e815c96b799";
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
