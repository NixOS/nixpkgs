{ lib, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "present";
  version = "0.6.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-l9W5L4LD9qRo3rLBkgd2I/aDaj+ucib5UYg+X4RYg6c=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    pyyaml
    pyfiglet
    asciimatics
    mistune
  ];

  pythonImportsCheck = [ "present" ];

  # TypeError: don't know how to make test from: 0.6.0
  doCheck = false;

  meta = with lib; {
    description = "A terminal-based presentation tool with colors and effects.";
    homepage = "https://github.com/vinayak-mehta/present";
    license = licenses.asl20;
    maintainers = with maintainers; [ lom ];
  };
}
