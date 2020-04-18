{ stdenv, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "adafruit-ampy";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dz5sksalccv4c3bzk3c1jxpg3s28lwlw8hfwc9dfxhw3a1np3fd";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ click python-dotenv pyserial ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/pycampers/ampy";
    license = licenses.mit;
    description = "Utility to interact with a MicroPython board over a serial connection.";
    maintainers = with maintainers; [ etu ];
  };
}
