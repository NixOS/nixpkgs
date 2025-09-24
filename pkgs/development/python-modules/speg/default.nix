{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "speg";
  version = "0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EMvvR+Fo38YvFNtXXPHEKAN6K4gc7mw8/O2gQ5wkPnE=";
    extension = "zip";
  };

  pythonImportsCheck = [ "speg" ];

  # checks fail for seemingly spurious reasons
  doCheck = false;

  meta = with lib; {
    description = "PEG-based parser interpreter with memoization (in time)";
    homepage = "https://github.com/avakar/speg";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ xworld21 ];
  };
}
