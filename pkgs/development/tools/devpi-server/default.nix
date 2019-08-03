 { stdenv, python3Packages, nginx }:

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "devpi-server";
  version = "4.9.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0cx0nv1qqv8lg6p1v8dv5val0dxnc3229c15imibl9wrhrffjbg9";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    devpi-common
    execnet
    itsdangerous
    passlib
    pluggy
    pyramid
    strictyaml
    waitress
  ];

  checkInputs = with python3Packages; [
    beautifulsoup4
    mock
    nginx
    pytest
    pytest-flakes
    pytestpep8
    webtest
  ];

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
