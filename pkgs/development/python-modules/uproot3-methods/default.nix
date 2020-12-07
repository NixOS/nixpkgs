{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward0
}:

buildPythonPackage rec {
  version = "0.10.0";
  pname = "uproot3-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rk9i1ra3panli96ghz80ddpqk77xb1kpxs3wf8rw0jy5d88pc26";
  };

  nativeBuildInputs = [ awkward0 ];

  propagatedBuildInputs = [ numpy awkward0 ];

  # No tests on PyPi
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/scikit-hep/uproot3-methods";
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc SuperSandro2000 ];
  };
}
