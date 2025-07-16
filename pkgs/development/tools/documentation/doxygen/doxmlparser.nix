{
  buildPythonPackage,
  doxygen,
  lxml,
  setuptools,
  six,
}:
buildPythonPackage rec {
  format = "setuptools";
  inherit (doxygen) version src;
  pname = "doxmlparser";

  sourceRoot = "${src.name}/addon/doxmlparser";

  build-system = [ setuptools ];

  dependencies = [
    lxml
    six
  ];

  pythonImportsCheck = [ "doxmlparser" ];

  meta = {
    inherit (doxygen.meta)
      license
      homepage
      changelog
      platforms
      ;
    description = "Library to parse the XML output produced by doxygen";
  };
}
