{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  gitUpdater,
  aiohttp,
  appdirs,
  beautifulsoup4,
  defusedxml,
  devpi-common,
  execnet,
  itsdangerous,
  nginx,
  packaging,
  passlib,
  platformdirs,
  pluggy,
  py,
  httpx,
  pyramid,
  pytest-asyncio,
  pytestCheckHook,
  repoze-lru,
  setuptools,
  setuptools-changelog-shortener,
  strictyaml,
  waitress,
  webtest,
  testers,
  devpi-server,
  nixosTests,
}:

buildPythonApplication rec {
  pname = "devpi-server";
  version = "6.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    rev = "server-${version}";
    hash = "sha256-YavMvPJQXKyyq+ql5BNUlfRXPsTV2ASzaUCMgyvwT0Y=";
  };

  sourceRoot = "${src.name}/server";

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--flake8" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-changelog-shortener
  ];

  propagatedBuildInputs = [
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

  nativeCheckInputs = [
    beautifulsoup4
    nginx
    py
    pytest-asyncio
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
  pytestFlags = [
    "-rfsxX"
  ];
  enabledTestPaths = [
    "./test_devpi_server"
  ];
  disabledTestPaths = [
    "test_devpi_server/test_nginx_replica.py"
    "test_devpi_server/test_streaming_nginx.py"
    "test_devpi_server/test_streaming_replica_nginx.py"
  ];
  disabledTests = [
    "test_fetch_later_deleted"
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

  meta = {
    homepage = "http://doc.devpi.net";
    description = "Github-style pypi index server and packaging meta tool";
    changelog = "https://github.com/devpi/devpi/blob/${src.rev}/server/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      confus
      makefu
    ];
  };
}
