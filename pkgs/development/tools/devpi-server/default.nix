{ lib, fetchFromGitHub, python3, nginx }:

let
  py = python3.override {
    packageOverrides = self: super: {
      # pyramid 2.0 no longer has a 'pyramid.compat' module
      pyramid = super.pyramid.overridePythonAttrs (oldAttrs: rec {
        version = "1.10.8";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "sha256-t81mWVvvkvgXZLl23d4rL6jk9fMl4C9l9ux/NwiynPY=";
        };
      });
    };
  };

in with py.pkgs;
buildPythonApplication rec {
  pname = "devpi-server";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    rev = "68ee291ef29a93f6d921d4927aec8d13919b4a4c";
    sha256 = "1ivd5dy9f2gq07w8n2gywa0n0d9wv8644l53ni9fz7i69jf8q2fm";
  };

  sourceRoot = "source/server";

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pluggy>=0.6.0,<1.0" "pluggy>=0.6.0,<2.0"
  '';

  propagatedBuildInputs = [
    py
    appdirs
    devpi-common
    defusedxml
    execnet
    itsdangerous
    repoze_lru
    passlib
    pluggy
    pyramid
    strictyaml
    waitress
  ] ++ passlib.optional-dependencies.argon2;

  checkInputs = [
    beautifulsoup4
    nginx
    pytestCheckHook
    pytest-flake8
    webtest
  ] ++ lib.optionals isPy27 [ mock ];

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
