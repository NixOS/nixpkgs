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
  version = "0.9.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f649a41d43b5a6c64bdcbd57e994932656b689f9593a86dd0be95778a2b47494";
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
