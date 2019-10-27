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
}:

buildPythonPackage rec {
  pname = "slicedimage";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "adab09457e22465f05998fdcf8ea14179185f8e780a4021526ba163dd476cd02";
  };

  propagatedBuildInputs = [
    boto3
    diskcache
    packaging
    numpy
    requests
    scikitimage
    six
  ] ++ lib.optionals isPy27 [ pathlib enum34 ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Library to access sliced imaging data";
    homepage = https://github.com/spacetx/slicedimage;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
