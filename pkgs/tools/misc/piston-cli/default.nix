{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "piston-cli";
  version = "1.2.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "bf0hhKb+6+07HhrkFrsWCnUQfsQWOdK/dPTlt9iZTno=";
  };

  propagatedBuildInputs = with python3Packages; [ rich prompt_toolkit requests pygments ];

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
