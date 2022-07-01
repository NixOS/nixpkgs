{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "inql";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "doyensec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0LPJMCg7F9kcPcq4jkADdCPNLfRThXu8QHy4qOn7+QU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    stickytape
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "inql"
  ];

  meta = with lib; {
    description = "Security testing tool for GraphQL";
    homepage = "https://github.com/doyensec/inql";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
