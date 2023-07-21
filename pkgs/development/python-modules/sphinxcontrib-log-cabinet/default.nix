{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptoolsLegacyNamespaceHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-log-cabinet";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "davidism";
    repo = "sphinxcontrib-log-cabinet";
    rev = "refs/tags/${version}";
    hash = "sha256-wXIDNHQelApRkaTv2wyGRD+yTDa9TazJwekqjd/VnQ0=";
  };

  nativeBuildInputs = [
    setuptoolsLegacyNamespaceHook
  ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinxcontrib.log_cabinet" ];

  doCheck = false; # no tests

  meta = with lib; {
    homepage = "https://github.com/davidism/sphinxcontrib-log-cabinet";
    description = "Sphinx extension to organize changelogs";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
