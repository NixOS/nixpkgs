{ lib, fetchFromGitHub, buildPythonApplication
, pythonOlder
, aiohttp
, appdirs
, beautifulsoup4
, defusedxml
, devpi-common
, execnet
, itsdangerous
, nginx
, packaging
, passlib
, platformdirs
, pluggy
, py
, pyramid
, pytestCheckHook
, repoze_lru
, setuptools
, strictyaml
, waitress
, webtest
}:


buildPythonApplication rec {
  pname = "devpi-server";
  version = "6.9.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    rev = "server-${version}";
    hash = "sha256-HnxWLxOK+6B8O/7lpNjuSUQ0Z7NOmV2n01WFyjow6oU=";
  };

  sourceRoot = "${src.name}/server";

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--flake8" ""
  '';

  nativeBuildInputs = [
    setuptools
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
    repoze_lru
    setuptools
    strictyaml
    waitress
  ] ++ passlib.optional-dependencies.argon2;

  nativeCheckInputs = [
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
    "--slow"
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
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "devpi_server"
  ];

  meta = with lib;{
    homepage = "http://doc.devpi.net";
    description = "Github-style pypi index server and packaging meta tool";
    changelog = "https://github.com/devpi/devpi/blob/${src.rev}/server/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
