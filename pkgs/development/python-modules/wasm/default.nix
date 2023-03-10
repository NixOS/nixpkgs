{ buildPythonPackage
, fetchPypi
, pythonAtLeast
, lib
}:

buildPythonPackage rec {
  pname = "wasm";
  version = "1.2";

  disabled = pythonAtLeast "3.10"; # project is abandoned, remove we whe move to py310/311

  src = fetchPypi {
    inherit pname version;
    sha256 = "179xcinfc35xgk0bf9y58kwxzymzk7c1p58w6khmqfiqvb91j3r8";
  };

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "wasm" ];

  meta = with lib; {
    description = "WebAssembly decoder and disassembler";
    homepage = "https://github.com/athre0z/wasm";
    changelog = "https://github.com/athre0z/wasm/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ arturcygan ];
  };
}
