{ lib
, buildPythonPackage
, fetchFromGitHub
, boto3
, diskcache
, enum34
, packaging
, pathlib
, numpy
, requests
, scikitimage
, six
, pytestCheckHook
, isPy27
, tifffile
}:

buildPythonPackage rec {
  pname = "slicedimage";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "spacetx";
    repo = pname;
    rev = version;
    sha256 = "1vpg8varvfx0nj6xscdfm7m118hzsfz7qfzn28r9rsfvrhr0dlcw";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Ignore tests which require setup, check again if disabledTestFiles can be used
  pytestFlagsArray = [ "--ignore tests/io_" ];

  pythonImportsCheck = [ "slicedimage" ];

  meta = with lib; {
    description = "Library to access sliced imaging data";
    homepage = "https://github.com/spacetx/slicedimage";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
