{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  wheel,
  numpy,
  python-dateutil,
  xxhash,
  pytestCheckHook,
  requests,
  xdoctest,
}:

buildPythonPackage rec {
  pname = "ubelt";
  version = "1.3.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Erotemic";
    repo = "ubelt";
    rev = "refs/tags/v${version}";
    hash = "sha256-ygoJqyTscfuZVDGVbrZobZFvlcuF4HavTU65tmhyU+w=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  optional-dependencies = {
    optional = [
      numpy
      python-dateutil
      xxhash
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    requests
    xdoctest
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # fail due to sandbox environment
    "CacheStamp.expired"
    "userhome"
  ];

  pythonImportsCheck = [ "ubelt" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python utility library with a stdlib like feel and extra batteries. Paths, Progress, Dicts, Downloads, Caching, Hashing: ubelt makes it easy";
    homepage = "https://github.com/Erotemic/ubelt";
    changelog = "https://github.com/Erotemic/ubelt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
