{ lib, fetchFromGitHub, buildPythonApplication, isPy27
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
  version = "6.7.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    rev = "server-${version}";
    hash = "sha256-tevQ/Ocusz2PythGnedP6r4xARgetVosAc8uTD49H3M=";
  };

  sourceRoot = "source/server";

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--flake8" ""
  '';

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

  checkInputs = [
    beautifulsoup4
    nginx
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
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib;{
    homepage = "http://doc.devpi.net";
    description = "Github-style pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
