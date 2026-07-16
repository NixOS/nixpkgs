{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
  requests,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-youtube";
  version = "1.5.0";
  pyproject = true;

  nativeBuildInputs = [ flit-core ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "youtube";
    tag = "v${version}";
    hash = "sha256-vzF1SC4fUIeR0OYesOq60eWjlX+N+YYA/h7mNfxWEtk=";
  };

  propagatedBuildInputs = [
    sphinx
    requests
  ];

  # tests require internet access
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.youtube" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Youtube extension for Sphinx";
    homepage = "https://github.com/sphinx-contrib/youtube";
    maintainers = with lib.maintainers; [ gador ];
    license = lib.licenses.bsd3;
  };
}
