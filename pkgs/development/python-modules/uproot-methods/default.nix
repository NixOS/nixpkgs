{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.2.7";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c9g7scq5nga6r2gn4j24xfs5rssn6z6aj4bhpk5ayzz8hhpss6w";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
