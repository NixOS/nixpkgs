{ lib
, buildPythonPackage
, fetchPypi
, boto3
, diskcache
, enum34
, packaging
, pathlib
, numpy
, requests
, scikitimage
, six
, pytest
, isPy27
, tifffile
}:

buildPythonPackage rec {
  pname = "slicedimage";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7369f1d7fa09f6c9969625c4b76a8a63d2507a94c6fc257183da1c10261703e9";
  };

  propagatedBuildInputs = [
    boto3
    diskcache
    packaging
    numpy
    requests
    scikitimage
    six
    tifffile
  ] ++ lib.optionals isPy27 [ pathlib enum34 ];

  checkInputs = [
    pytest
  ];

  # ignore tests which require setup
  checkPhase = ''
    pytest --ignore tests/io_
  '';

  meta = with lib; {
    description = "Library to access sliced imaging data";
    homepage = https://github.com/spacetx/slicedimage;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
