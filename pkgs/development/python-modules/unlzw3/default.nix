{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "unlzw3";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0DeptoI9GkVdbeHgJYr4wPXb9Aq6OxnMUURI542ncGI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    homepage = "https://pypi.org/project/unlzw3/";
    license = licenses.mit;
    description = "Pure Python decompression module for .Z files compressed using Unix compress utility";
    maintainers = [ maintainers.gm6k ];
  };
}
