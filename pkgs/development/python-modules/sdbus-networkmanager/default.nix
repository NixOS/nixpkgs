{
  buildPythonPackage,
  fetchPypi,
  sdbus,
}:

let
  pname = "sdbus-networkmanager";
  version = "2.0.0";
in
buildPythonPackage {
  inherit pname version;

  propagatedBuildInputs = [ sdbus ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NXKsOoGJxoPsBBassUh2F3Oo8Iga09eLbW9oZO/5xQs=";
  };
}
