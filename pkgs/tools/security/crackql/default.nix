{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "crackql";
  version = "unstable-20230818";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nicholasaleks";
    repo = "CrackQL";
    # rev = "refs/tags/${version}";
    # Switch to tag with the next update
    rev = "ac26a44c2dd201f65da0d1c3f95eaf776ed1b2dd";
    hash = "sha256-XlHbGkwdOV1nobjtQP/M3IIEuzXHBuwf52EsXf3MWoM=";
  };

  pythonRelaxDeps = [
    "graphql-core"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    graphql-core
    jinja2
    typing-extensions
  ];

  meta = with lib; {
    description = "GraphQL password brute-force and fuzzing utility";
    mainProgram = "crackql";
    homepage = "https://github.com/nicholasaleks/CrackQL";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
