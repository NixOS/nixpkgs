{
  buildPythonPackage,
  fetchPypi,
  lib,
  poetry-core,
  sphinx,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "sphinxawesome-theme";
  version = "5.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxawesome_theme";
    hash = "sha256-wk8eXAueR1OA0W/F8fO/2ElVgX2gkF2V9+IICdfNPF0=";
  };

  build-system = [ poetry-core ];
  dependencies = [
    sphinx
    beautifulsoup4
  ];

  pythonRelaxDeps = [ "sphinx" ];

  meta = {
    description = "Awesome Sphinx Theme";
    homepage = "https://sphinxawesome.xyz/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
