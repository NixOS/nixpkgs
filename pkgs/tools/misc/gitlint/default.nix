{ lib
, buildPythonApplication
, fetchFromGitHub
, gitMinimal
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitlint";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "jorisroovers";
    repo = "gitlint";
    rev = "v${version}";
    sha256 = "sha256-RXBMb43BBiJ23X0eKC1kqgLw8iFKJnP5iejY0AWcUrU=";
  };

  # Upstream splitted the project into gitlint and gitlint-core to
  # simplify the dependency handling
  sourceRoot = "source/gitlint-core";

  propagatedBuildInputs = with python3.pkgs; [
    arrow
    click
    sh
  ];

  checkInputs = with python3.pkgs; [
    gitMinimal
    pytestCheckHook
  ];

  postPatch = ''
    # We don't need gitlint-core
    substituteInPlace setup.py \
      --replace "'gitlint-core[trusted-deps]==' + version," ""
  '';

  pythonImportsCheck = [
    "gitlint"
  ];

  meta = with lib; {
    description = "Linting for your git commit messages";
    homepage = "https://jorisroovers.com/gitlint/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 fab ];
  };
}
