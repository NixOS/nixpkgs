{ stdenv, fetchFromGitHub, python3Packages, nginx }:

python3Packages.buildPythonApplication rec {
  pname = "devpi-server";
  version = "6.0.0.dev0";

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    rev = "68ee291ef29a93f6d921d4927aec8d13919b4a4c";
    sha256 = "1ivd5dy9f2gq07w8n2gywa0n0d9wv8644l53ni9fz7i69jf8q2fm";
  };
  sourceRoot = "source/server";

  propagatedBuildInputs = with python3Packages; [
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
  ];

  checkInputs = with python3Packages; [
    beautifulsoup4
    nginx
    pytest
    pytest-flake8
    pytestpep8
    webtest
  ] ++ stdenv.lib.optionals isPy27 [ mock ];

  # root_passwd_hash tries to write to store
  # TestMirrorIndexThings tries to write to /var through ngnix
  # nginx tests try to write to /var
  checkPhase = ''
    PATH=$PATH:$out/bin HOME=$TMPDIR pytest \
      ./test_devpi_server --slow -rfsxX \
      --ignore=test_devpi_server/test_nginx_replica.py \
      --ignore=test_devpi_server/test_streaming_nginx.py \
      --ignore=test_devpi_server/test_streaming_replica_nginx.py \
      -k 'not root_passwd_hash_option \
          and not TestMirrorIndexThings'
  '';

  meta = with stdenv.lib;{
    homepage = "http://doc.devpi.net";
    description = "Github-style pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
