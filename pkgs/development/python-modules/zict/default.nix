{ stdenv, buildPythonPackage, fetchPypi
, pytest, heapdict }:

buildPythonPackage rec {
  pname = "zict";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04532600mnsvzv43l2jvjrn7sflg0wkjqzy7nj7m3vvxm5gd4kg3";
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
