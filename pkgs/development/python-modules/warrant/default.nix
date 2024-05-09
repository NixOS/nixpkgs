{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch
, mock
, boto3, envs, python-jose, requests }:

buildPythonPackage {
  pname = "warrant";
  version = "0.6.1";
  format = "setuptools";

  # move to fetchPyPi when https://github.com/capless/warrant/issues/97 is fixed
  src = fetchFromGitHub {
    owner  = "capless";
    repo   = "warrant";
    rev    = "ff2e4793d8479e770f2461ef7cbc0c15ee784395";
    sha256 = "0gw3crg64p1zx3k5js0wh0x5bldgs7viy4g8hld9xbka8q0374hi";
  };

  patches = [
    (fetchpatch {
      name = "fix-pip10-compat.patch";
      url = "https://github.com/capless/warrant/commit/ae17d17d9888b9218a8facf6f6ad0bf4adae9a12.patch";
      sha256 = "1lvqi2qfa3kxdz05ab2lc7xnd3piyvvnz9kla2jl4pchi876z17c";
    })
  ];

  # this needs to go when 0.6.2 or later is released
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "python-jose-cryptodome>=1.3.2" "python-jose>=2.0.0"
  '';

  nativeCheckInputs = [ mock ];

  propagatedBuildInputs = [ boto3 envs python-jose requests ];

  # all the checks are failing
  doCheck = false;

  meta = with lib; {
    description = "Python library for using AWS Cognito with support for SRP";
    homepage = "https://github.com/capless/warrant";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
