{ stdenv, python3Packages, nginx }:

python3Packages.buildPythonApplication rec {
  pname = "devpi-server";
  version = "5.5.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0lily4a0k13bygx07x2f2q4nkwny0fj34hpac9i6mc70ysdn1hhi";
  };

  propagatedBuildInputs = with python3Packages; [
    py
    appdirs
    devpi-common
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
