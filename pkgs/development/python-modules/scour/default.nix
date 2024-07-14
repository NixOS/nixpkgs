{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "scour";
  version = "0.38.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aIHsJmYMEwxezZlqxvawOTndV0GY9Qdz8lCLgaaODa8=";
  };

  propagatedBuildInputs = [ six ];

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    description = "SVG Optimizer / Cleaner ";
    mainProgram = "scour";
    homepage = "https://github.com/scour-project/scour";
    license = licenses.asl20;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
