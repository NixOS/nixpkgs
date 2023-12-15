{ stdenv, lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "piston-cli";
  version = "1.4.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "qvDGVJcaMXUajdUQWl4W1dost8k0PsS9XX/o8uQrtfY=";
  };

  propagatedBuildInputs = with python3Packages; [ rich prompt-toolkit requests pygments pyyaml more-itertools ];

  checkPhase = ''
    $out/bin/piston --help > /dev/null
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "rich"
    "more-itertools"
    "PyYAML"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Piston api tool";
    homepage = "https://github.com/Shivansh-007/piston-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    mainProgram = "piston";
  };
}
