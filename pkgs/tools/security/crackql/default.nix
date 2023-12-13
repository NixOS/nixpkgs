{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "crackql";
  version = "unstable-20220821";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nicholasaleks";
    repo = "CrackQL";
    # rev = "refs/tags/${version}";
    # Switch to tag with the next update
    rev = "5bcf92f4520a4dd036baf9f47c5ebbf18e6a032a";
    hash = "sha256-XlHbGkwdOV1nobjtQP/M3IIEuzXHBuwf52EsXf3MWoM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    graphql-core
    jinja2
    typing-extensions
  ];

  meta = with lib; {
    description = "GraphQL password brute-force and fuzzing utility";
    homepage = "https://github.com/nicholasaleks/CrackQL";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
