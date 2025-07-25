{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
  nginx,
  testers,
  devpi-server,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "devpi-server";
  version = "6.15.0";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    rev = "server-${version}";
    hash = "sha256-tKR1xZju5bDbFu8t3SunTM8FlaXodSm/OjJ3Jfl7Dzk=";
  };

  sourceRoot = "${src.name}/server";

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--flake8" ""
  '';

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      aiohttp
      appdirs
      defusedxml
      devpi-common
      execnet
      itsdangerous
      packaging
      passlib
      platformdirs
      pluggy
      pyramid
      repoze-lru
      setuptools
      strictyaml
      waitress
      py
      httpx
    ]
    ++ passlib.optional-dependencies.argon2;

  nativeCheckInputs = with python3Packages; [
    beautifulsoup4
    nginx
    py
    pytestCheckHook
    webtest
  ];

  # root_passwd_hash tries to write to store
  # TestMirrorIndexThings tries to write to /var through ngnix
  # nginx tests try to write to /var
  preCheck = ''
    export PATH=$PATH:$out/bin
    export HOME=$TMPDIR
  '';
  pytestFlagsArray = [
    "./test_devpi_server"
    "-rfsxX"
    "--ignore=test_devpi_server/test_nginx_replica.py"
    "--ignore=test_devpi_server/test_streaming_nginx.py"
    "--ignore=test_devpi_server/test_streaming_replica_nginx.py"
  ];
  disabledTests = [
    "root_passwd_hash_option"
    "TestMirrorIndexThings"
    "test_auth_mirror_url_no_hash"
    "test_auth_mirror_url_with_hash"
    "test_auth_mirror_url_hidden_in_logs"
    "test_simplelinks_timeout"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "devpi_server"
  ];

  passthru.tests = {
    devpi-server = nixosTests.devpi-server;
    version = testers.testVersion {
      package = devpi-server;
    };
  };

  # devpi uses a monorepo for server,common,client and web
  passthru.updateScript = gitUpdater {
    rev-prefix = "server-";
  };

  meta = with lib; {
    homepage = "http://doc.devpi.net";
    description = "Github-style pypi index server and packaging meta tool";
    changelog = "https://github.com/devpi/devpi/blob/${src.rev}/server/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
