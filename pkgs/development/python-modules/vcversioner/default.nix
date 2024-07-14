{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "vcversioner";
  version = "2.16.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2uYMF6R5eB9EpAEHAYM/GCkUCx7szSWHYqdJdKoG4Zs=";
  };

  meta = with lib; {
    description = "take version numbers from version control";
    homepage = "https://github.com/habnabit/vcversioner";
    license = licenses.isc;
  };
}
