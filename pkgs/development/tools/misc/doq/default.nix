{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "doq";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "heavenshell";
    repo = "py-doq";
    rev = "refs/tags/${version}";
    hash = "sha256-iVu+5o8pZ5OhIzNItWbzUzqC3VQ6HCD7nP5gW/PVAMM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-generate
  ];

  propagatedBuildInputs = with python3.pkgs; [
    jinja2
    parso
    toml
  ];

  nativeCheckInputs = with python3.pkgs; [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [ "doq" ];

  meta = with lib; {
    description = "Docstring generator for Python";
    homepage = "https://github.com/heavenshell/py-doq";
    changelog = "https://github.com/heavenshell/py-doq/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "doq";
  };
}
