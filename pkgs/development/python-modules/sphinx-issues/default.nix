{
  lib,
  buildPythonPackage,
  sphinx,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "sphinx-issues";
  version = "3.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "sphinx-issues";
    rev = version;
    sha256 = "1lns6isq9kwcw8z4jwgy927f7idx9srvri5adaa5zmypw5x47hha";
  };

  pythonImportsCheck = [ "sphinx_issues" ];

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    homepage = "https://github.com/sloria/sphinx-issues";
    description = "Sphinx extension for linking to your project's issue tracker";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
