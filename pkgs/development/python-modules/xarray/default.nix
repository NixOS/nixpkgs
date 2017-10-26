{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, pandas
, python
, fetchurl
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.9.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f649a41d43b5a6c64bdcbd57e994932656b689f9593a86dd0be95778a2b47494";
  };

  # Temporary patch until next release (later than 0.9.6) to fix
  # a broken test case.
  patches = [
    (fetchurl {
      url = "https://github.com/pydata/xarray/commit/726c6a3638ecf95889c541d84e892a106c2f2f92.patch";
      sha256 = "1i2hsj5v5qlvqfj48vyn9931yndsf4k4wrk3qpqpywh32s7r007b";
    })
  ];

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
