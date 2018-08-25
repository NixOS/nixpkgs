{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "adafruit-ampy";

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "ampy";
    rev  = "1.0.5";
    sha256 = "1h71w8dx49bmdawnwvnywmc95nqbd5pxcl6kdia55lxalas3pzw6";
  };

  propagatedBuildInputs = with pythonPackages; [
    pyserial
    click
    python-dotenv
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Utility to interact with a MicroPython board over a serial connection";
    homepage = https://github.com/adafruit/ampy;
    license = stdenv.lib.licenses.mit;
    maintainers = [];
    platforms = stdenv.lib.platforms.unix;
  };
}
