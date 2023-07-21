{ lib
, buildPythonPackage
, fetchPypi
, setuptoolsLegacyNamespaceHook
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-qthelp";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TDN2fuBYtw26iab8XBiSwNV6VL5n3dPnh1oY0Uy6WnI=";
  };

  nativeBuildInputs = [
    setuptoolsLegacyNamespaceHook
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-qthelp is a sphinx extension which outputs QtHelp document";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-qthelp";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}
