{
  buildPythonPackage,
  fetchPypi,
  lib,
  poetry-core,
  sphinx,
  beautifulsoup4,
  pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "sphinxawesome-theme";
  version = "5.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinxawesome_theme";
    hash = "sha256-OwikuKJrPo4vNaud/9JToYYJePV6Kew8izYbr/qKTtQ=";
  };

  build-system = [ poetry-core pythonRelaxDepsHook ];
  dependencies = [
    sphinx
    beautifulsoup4
  ];

  pythonRelaxDeps = [ "sphinx" ];

  meta = {
    description = "Awesome Sphinx Theme";
    homepage = "https://sphinxawesome.xyz/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [sigmanificient];
  };
}
