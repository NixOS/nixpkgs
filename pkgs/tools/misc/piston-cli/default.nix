{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "piston-cli";
  version = "1.4.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "o8GPtSQ119AKB64hAH8VY6iJmhXcSFqjOanmXQl0tHo=";
  };

  propagatedBuildInputs = with python3Packages; [ rich prompt_toolkit requests pygments pyyaml ];

  checkPhase = ''
    $out/bin/piston --help > /dev/null
  '';

  meta = with lib; {
    description = "Piston api tool";
    homepage = "https://github.com/Shivansh-007/piston-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
