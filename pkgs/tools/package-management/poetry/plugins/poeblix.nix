{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry
}:

buildPythonPackage rec {
  pname = "poeblix";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spoorn";
    repo = "poeblix";
    rev = "refs/tags/${version}";
    hash = "sha256-TKadEOk9kM3ZYsQmE2ftzjHNGNKI17p0biMr+Nskigs=";
  };

  build-system = [
    poetry-core
  ];

  buildInputs = [
    poetry
  ];

  pythonImportsCheck = ["poeblix"];

  # poeblix tests currently fail with Python 3.11: https://github.com/spoorn/poeblix/issues/22
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/spoorn/poeblix/releases/tag/${src.rev}";
    description = "Poetry plugin for building wheel files with locked dependencies and validating wheel/docker containers";
    license = licenses.mit;
    homepage = "https://github.com/spoorn/poeblix";
    maintainers = with maintainers; [ hennk ];
  };
}
