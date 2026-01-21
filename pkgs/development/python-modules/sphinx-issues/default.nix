{
  lib,
  buildPythonPackage,
  sphinx,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "sphinx-issues";
  version = "5.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "sphinx-issues";
    tag = version;
    sha256 = "sha256-/nc5gtZbE1ziMPWIkZTkevMfVkNtJYL/b5QLDeMhzUs=";
  };

  pythonImportsCheck = [ "sphinx_issues" ];

  propagatedBuildInputs = [ sphinx ];

  meta = {
    homepage = "https://github.com/sloria/sphinx-issues";
    description = "Sphinx extension for linking to your project's issue tracker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
