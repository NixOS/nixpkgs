{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "unpaddedbase64";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "python-${pname}";
    tag = "v${version}";
    sha256 = "1n6har8pxv0mqb96lanzihp1xf76aa17jw3977drb1fgz947pnmz";
  };

  nativeBuildInputs = [ poetry-core ];

  meta = with lib; {
    homepage = "https://github.com/matrix-org/python-unpaddedbase64";
    description = "Unpadded Base64";
    license = licenses.asl20;
  };
}
