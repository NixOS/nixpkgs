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
  version = "1.4.1";
  pyproject = true;

  nativeBuildInputs = [ flit-core ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "youtube";
    tag = "v${version}";
    hash = "sha256-XuOfZ77tg9akmgTuMQN20OhgkFbn/6YzT46vpTsXxC8=";
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
