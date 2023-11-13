{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "doq";
  version = "0.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "heavenshell";
    repo = "py-doq";
    rev = "refs/tags/${version}";
    hash = "sha256-6ff7R/2Jo4jYm1hA70yopjklpKIMWlj7DH9eKxOlfgU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    jinja2
    parso
    toml
  ];

  nativeCheckInputs = with python3.pkgs; [
    parameterized
    unittestCheckHook
  ];

  pythonImportsCheck = [ "doq" ];

  meta = with lib; {
    description = "Docstring generator for Python";
    homepage = "https://github.com/heavenshell/py-doq";
    changelog = "https://github.com/heavenshell/py-doq/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ natsukium ];
  };
}
