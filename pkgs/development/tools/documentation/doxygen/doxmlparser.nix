{
  buildPythonPackage,
  doxygen,
  lxml,
  setuptools,
  six,
}:
buildPythonPackage rec {
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
    description = "easier to parse the XML output produced by doxygen";
  };
}
