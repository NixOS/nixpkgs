{ stdenv, buildPythonPackage, fetchPypi
, pytest, heapdict }:

buildPythonPackage rec {
  pname = "zict";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7838b2f21bc06b7e3db5c64ffa6642255a5f7c01841660b3388a9840e101f99";
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
