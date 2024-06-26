{
  lib,
  buildPythonApplication,
  docopt,
  fetchFromGitHub,
  importlib-metadata,
  poetry-core,
}:

buildPythonApplication rec {
  pname = "xortool";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hellman";
    repo = pname;
    rev = "v${version}";
    sha256 = "19lfadi28r89bl5q8fhrxgjgs3nx3kgjd4rdg7wbvzi1cn29c5n7";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    docopt
    importlib-metadata
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "xortool" ];

  meta = with lib; {
    description = "Tool to analyze multi-byte XOR cipher";
    homepage = "https://github.com/hellman/xortool";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
