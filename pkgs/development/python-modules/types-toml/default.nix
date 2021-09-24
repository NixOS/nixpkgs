{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64f88a257dd62465b01fcf0d1ed4ffcaf19e320ee3e731c26a2e9dcc5090fdbb";
  };

  pythonImportsCheck = [ "toml-stubs" ];

  meta = with lib; {
    description = "Typing stubs for toml";
    homepage = "https://github.com/python/typeshed/tree/master/stubs/toml";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj veehaitch ];
  };
}
