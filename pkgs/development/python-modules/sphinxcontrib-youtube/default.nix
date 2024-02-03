{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, requests
, flit-core
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-youtube";
  version = "1.3.0";
  format = "pyproject";

  nativeBuildInputs = [ flit-core ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "youtube";
    rev = "refs/tags/v${version}";
    hash = "sha256-/mu/OGMc+iP7DV36fmE8pb5y6MMOQ0fmzT8R7RP/tjM=";
  };

  propagatedBuildInputs = [ sphinx requests ];

  # tests require internet access
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.youtube" ];

  meta = with lib; {
    description = "Youtube extension for Sphinx";
    homepage = "https://github.com/sphinx-contrib/youtube";
    maintainers = with maintainers; [ gador ];
    license = licenses.bsd3;
  };
}
