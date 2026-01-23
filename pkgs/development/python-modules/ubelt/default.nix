{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Erotemic";
    repo = "ubelt";
    tag = "v${version}";
    hash = "sha256-9f22hNi/YrxAVoEOGojdziogUN/YNCrpUuOfib9nqfQ=";
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

  meta = {
    description = "Python utility library with a stdlib like feel and extra batteries. Paths, Progress, Dicts, Downloads, Caching, Hashing: ubelt makes it easy";
    homepage = "https://github.com/Erotemic/ubelt";
    changelog = "https://github.com/Erotemic/ubelt/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
