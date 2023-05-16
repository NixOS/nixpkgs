<<<<<<< HEAD
{ stdenv, lib, python3Packages, fetchPypi }:
=======
{ stdenv, lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "piston-cli";
  version = "1.4.3";
  format = "pyproject";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "qvDGVJcaMXUajdUQWl4W1dost8k0PsS9XX/o8uQrtfY=";
  };

  propagatedBuildInputs = with python3Packages; [ rich prompt-toolkit requests pygments pyyaml more-itertools ];

  checkPhase = ''
    $out/bin/piston --help > /dev/null
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
<<<<<<< HEAD
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "rich"
    "more-itertools"
    "PyYAML"
  ];
=======
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^10.1.0"' 'rich = "*"' \
      --replace 'PyYAML = "^5.4.1"' 'PyYAML = "*"'
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Piston api tool";
    homepage = "https://github.com/Shivansh-007/piston-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
