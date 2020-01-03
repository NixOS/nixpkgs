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
  version = "4.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8e8759a013a0936ec9f7ffcd37fc64df69af913b4f26342c2501b8c3663d9bb";
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
