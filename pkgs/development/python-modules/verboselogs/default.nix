{ lib, buildPythonPackage, fetchFromGitHub, pytest, mock }:

buildPythonPackage rec {
  pname = "verboselogs";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-verboselogs";
    rev = version;
    sha256 = "10jzm8pkl49as4y2zyiidmfqqj5zmqg3p73jvx4lfxi0gmp1vhl5";
  };

  # do not run pylint plugin test, as astroid is a old unsupported version
  checkPhase = ''
    PATH=$PATH:$out/bin pytest . -k "not test_pylint_plugin"
  '';
  checkInputs = [ pytest mock ];

  meta = with lib; {
    description = "Verbose logging for Python's logging module";
    homepage = "https://github.com/xolox/python-verboselogs";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
