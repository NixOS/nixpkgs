 { stdenv, pythonPackages, glibcLocales, nginx }:

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "devpi-server";
  version = "4.3.1";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0x6ks2sbpknznxaqlh0gf5hcvhkmgixixq2zs91wgfqxk4vi4s6n";
  };

  propagatedBuildInputs = with pythonPackages;
    [ devpi-common execnet itsdangerous pluggy waitress pyramid passlib ];
  checkInputs = with pythonPackages; [ nginx webtest pytest beautifulsoup4 pytest-timeout pytest-catchlog mock pyyaml ];
  checkPhase = ''
    cd test_devpi_server/
    PATH=$PATH:$out/bin pytest --slow -rfsxX
  '';

  meta = with stdenv.lib;{
    homepage = http://doc.devpi.net;
    description = "Github-style pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
