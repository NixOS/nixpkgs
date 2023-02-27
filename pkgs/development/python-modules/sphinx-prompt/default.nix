{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, sphinxHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-prompt";
  version = "1.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sbrunner";
    repo = "sphinx-prompt";
    rev = "refs/tags/${version}";
    hash = "sha256-OA1ltdS+JUxKfyoZkbnIYPpAJthRBa/DH0WPb/orxuw=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "A sphinx extension for creating unselectable prompt";
    homepage = "https://github.com/sbrunner/sphinx-prompt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
