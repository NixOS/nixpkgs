{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.7.4";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f110208a3a2aa9b4d6da11233fd0f206ea039b52bca4bfe312f1b9dcf788476";
  };

  propagatedBuildInputs = [ numpy awkward ];

  # No tests on PyPi
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/scikit-hep/uproot-methods";
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
