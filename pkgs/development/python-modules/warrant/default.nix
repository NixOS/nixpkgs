{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  mock,
  boto3,
  envs,
  python-jose,
  requests,
}:

buildPythonPackage {
  pname = "warrant";
  version = "0.6.1";
  pyproject = true;

  __structuredAttrs = true;

  # move to fetchPyPi when https://github.com/capless/warrant/issues/97 is fixed
  src = fetchFromGitHub {
    owner = "capless";
    repo = "warrant";
    rev = "ff2e4793d8479e770f2461ef7cbc0c15ee784395";
    hash = "sha256-EZIzAEZqrp4ahegRH/fRr9FVOoAcaFnm6D9cYl5mgz8=";
  };

  patches = [
    (fetchpatch {
      name = "fix-pip10-compat.patch";
      url = "https://github.com/capless/warrant/commit/ae17d17d9888b9218a8facf6f6ad0bf4adae9a12.patch";
      hash = "sha256-7IRvDoqQXUKlUHSmb/f28Y5m+2FULFXAb30O5bCIeNM=";
    })
  ];

  build-system = [ setuptools ];

  # this needs to go when 0.6.2 or later is released
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace-fail "python-jose-cryptodome>=1.3.2" "python-jose>=2.0.0"
  '';

  nativeCheckInputs = [ mock ];

  dependencies = [
    boto3
    envs
    python-jose
    requests
  ];

  # all the checks are failing
  doCheck = false;

  pythonImportsCheck = [ "warrant" ];

  meta = {
    description = "Python library for using AWS Cognito with support for SRP";
    homepage = "https://github.com/capless/warrant";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
