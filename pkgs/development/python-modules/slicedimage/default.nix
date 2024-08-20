{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boto3,
  diskcache,
  packaging,
  numpy,
  requests,
  scikit-image,
  six,
  pytestCheckHook,
  tifffile,
}:

buildPythonPackage rec {
  pname = "slicedimage";
  version = "4.1.1";
  format = "setuptools";

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
    scikit-image
    six
    tifffile
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Ignore tests which require setup, check again if disabledTestFiles can be used
  pytestFlagsArray = [ "--ignore tests/io_" ];

  pythonImportsCheck = [ "slicedimage" ];

  meta = with lib; {
    description = "Library to access sliced imaging data";
    mainProgram = "slicedimage";
    homepage = "https://github.com/spacetx/slicedimage";
    license = licenses.mit;
    maintainers = [ ];
  };
}
