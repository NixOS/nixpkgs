{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "timeloop";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sankalpjonn";
    repo = "timeloop";
    rev = "refs/tags/v${version}";
    hash = "sha256-HHbhqMH+xN6LRWQe48lDP1A0mwbhK8i0EnATXfxcrQ0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "timeloop" ];

  doCheck = false; # no tests

  meta = {
    description = "Elegant periodic task executor";
    homepage = "https://github.com/sankalpjonn/timeloop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
