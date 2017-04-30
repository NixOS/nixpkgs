{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, pandas
, python
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.9.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d23bfcc317829570daa1fe8306ad7ff62cd77847bbd68e3ffc53d847bff7c36d";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [numpy pandas];

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

  meta = {
    description = "N-D labeled arrays and datasets in Python";
    homepage = https://github.com/pydata/xarray;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
