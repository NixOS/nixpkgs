{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "unpaddedbase64";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "python-${pname}";
    tag = "v${version}";
    hash = "sha256-v9p7SPrPhZXbOWlweYJS5rgeLozfKmrSwhXsflFW0Ng=";
  };

  nativeBuildInputs = [ poetry-core ];

  meta = {
    homepage = "https://github.com/matrix-org/python-unpaddedbase64";
    description = "Unpadded Base64";
    license = lib.licenses.asl20;
  };
}
