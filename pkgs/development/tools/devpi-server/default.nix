{ stdenv, python3Packages, nginx }:

python3Packages.buildPythonApplication rec {
  pname = "devpi-server";
  version = "5.1.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "254fceee846532a5fec4e6bf52a59eb8f236efc657678a542b5200da4bb3abbc";
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
  checkPhase = ''
    PATH=$PATH:$out/bin pytest ./test_devpi_server --slow -rfsxX
  '';

  meta = with stdenv.lib;{
    homepage = http://doc.devpi.net;
    description = "Github-style pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
