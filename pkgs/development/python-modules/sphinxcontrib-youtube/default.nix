{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, requests
, flit-core
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-youtube";
  version = "1.2.0";
  format = "pyproject";

  nativeBuildInputs = [ flit-core ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "youtube";
    rev = "v${version}";
    hash = "sha256-SUnnrzYJ6cOktE0IdnRWTvPGcL/eVS9obtHBMpS2s4A=";
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
