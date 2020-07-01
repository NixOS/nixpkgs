{ stdenv, buildPythonPackage, fetchPypi
, pytest, heapdict }:

buildPythonPackage rec {
  pname = "zict";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e2969797627c8a663575c2fc6fcb53a05e37cdb83ee65f341fc6e0c3d0ced16";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ heapdict ];

  meta = with stdenv.lib; {
    description = "Mutable mapping tools.";
    homepage = "https://github.com/dask/zict";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
