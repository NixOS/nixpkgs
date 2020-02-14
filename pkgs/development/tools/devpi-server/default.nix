{ stdenv, python3Packages, nginx }:

python3Packages.buildPythonApplication rec {
  pname = "devpi-server";
  version = "5.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1dapd0bis7pb4fzq5yva7spby5amcsgl1970z5nq1rlprf6qbydg";
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

  # test_genconfig.py needs devpi-server on PATH
  # root_passwd_hash tries to write to store
  checkPhase = ''
    PATH=$PATH:$out/bin HOME=$TMPDIR pytest \
      ./test_devpi_server --slow -rfsxX \
      -k 'not root_passwd_hash_option'
  '';

  meta = with stdenv.lib;{
    homepage = http://doc.devpi.net;
    description = "Github-style pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
