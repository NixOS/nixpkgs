{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonAtLeast,
  requests,
  stups-cli-support,
  stups-zign,
  pytest,
  pytest-cov-stub,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "stups-fullstop";
  version = "1.1.31";
  format = "setuptools";
  disabled = !isPy3k || pythonAtLeast "3.11"; # Uses regex patterns deprecated in 3.9, errors in 3.11+

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "fullstop-cli";
    rev = version;
    hash = "sha256-AwKFedZjc4EaDUqgyN/tdIPDn9vk3MAOZLGKh1b4/7I=";
  };

  propagatedBuildInputs = [
    requests
    stups-cli-support
    stups-zign
  ];

  preCheck = "
    export HOME=$TEMPDIR
  ";

  nativeCheckInputs = [
    pytest
    pytest-cov-stub
  ];

  meta = {
    description = "Convenience command line tool for fullstop. audit reporting";
    homepage = "https://github.com/zalando-stups/stups-fullstop-cli";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mschuwalow ];
  };
}
