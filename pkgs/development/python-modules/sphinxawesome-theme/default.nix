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
  version = "5.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxawesome_theme";
    hash = "sha256-BinTi4Cu/CebEYbFOnpvryHnIbWy7NoU9IjKEHTiYx8=";
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
