{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, awkward
}:

buildPythonPackage rec {
  version = "0.2.6";
  pname = "uproot-methods";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z8gganf8p68z586zzx440dpkar3djdbc4f7670bkriyix0z6lxn";
  };

  propagatedBuildInputs = [ numpy awkward ];

  meta = with stdenv.lib; {
    homepage = https://github.com/scikit-hep/uproot-methods;
    description = "Pythonic mix-ins for ROOT classes";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
