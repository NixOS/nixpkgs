{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  aiohttp,
  aiohttp-jinja2,
  jinja2,
  rich,
  textual,
}:

buildPythonPackage rec {
  pname = "textual-serve";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "textual_serve";
    inherit version;
    hash = "sha256-ccZiRyxGLl42je/GYO5ujq47/aiMpAwFDFVHRobrDFQ=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    aiohttp
    aiohttp-jinja2
    jinja2
    rich
    textual
  ];

  meta = {
    description = "Serve Textual apps locally";
    homepage = "https://github.com/Textualize/textual-serve";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gepbird
    ];
  };
}
