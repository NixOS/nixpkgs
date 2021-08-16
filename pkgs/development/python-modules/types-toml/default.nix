{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nfwymw2pmc88w524ypamc62nwqfky75cqqc6vj08m145kwisppw";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "toml-stubs" ];

  meta = with lib; {
    description = "Typing stubs for toml";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicoo ];
  };
}
