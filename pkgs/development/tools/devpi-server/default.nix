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

buildPythonApplication (finalAttrs: {
  pname = "devpi-server";
  version = "6.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    tag = "server-${finalAttrs.version}";
    hash = "sha256-YFY2iLnORzFxnfGYU2kCpJL8CZi+lALIkL1bRpfd4NE=";
  };

  sourceRoot = "${finalAttrs.src.name}/server";

  build-system = [
    setuptools
    setuptools-changelog-shortener
  ];

  dependencies = [
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
    "test_fetch_later_deleted" # incompatible with newer pytest
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

  # devpi uses a monorepo for server, common, client and web
  passthru.updateScript = gitUpdater {
    rev-prefix = "server-";
  };

  meta = {
    homepage = "http://doc.devpi.net";
    description = "Github-style pypi index server and packaging meta tool";
    changelog = "https://github.com/devpi/devpi/blob/${finalAttrs.src.tag}/server/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      confus
      makefu
    ];
  };
})
