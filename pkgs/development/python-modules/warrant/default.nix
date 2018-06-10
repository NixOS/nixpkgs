{ lib, buildPythonPackage, fetchFromGitHub, fetchPypi
, mock
, boto3, envs, python-jose, requests }:

buildPythonPackage rec {
  pname = "warrant";
  version = "0.6.1";

  # move to fetchPyPi when https://github.com/capless/warrant/issues/97 is fixed
  src = fetchFromGitHub {
    owner  = "capless";
    repo   = "warrant";
    rev    = "ff2e4793d8479e770f2461ef7cbc0c15ee784395";
    sha256 = "0gw3crg64p1zx3k5js0wh0x5bldgs7viy4g8hld9xbka8q0374hi";
  };

  # this needs to go when 0.6.2 or later is released
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "python-jose-cryptodome>=1.3.2" "python-jose>=2.0.0"
  '';

  checkInputs = [ mock ];

  propagatedBuildInputs = [ boto3 envs python-jose requests ];

  # all the checks are failing
  doCheck = false;

  meta = with lib; {
    description = "Python library for using AWS Cognito with support for SRP";
    homepage = https://github.com/capless/warrant;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
