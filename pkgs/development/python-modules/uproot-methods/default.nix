{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0awxd4p8yr27k4iayc0phw99bxgw04dnd3lb372hj9wjvldm0hzr";
  };

  propagatedBuildInputs = [ numpy awkward ];

  # No tests on PyPi
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
