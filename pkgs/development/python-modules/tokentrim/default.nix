{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, tiktoken
}:

buildPythonPackage {
  pname = "tokentrim";
  version = "unstable-2023-09-07";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KillianLucas";
    repo = "tokentrim";
    rev = "e98ad3a2ca0e321a7347f76c30be584175495139";
    hash = "sha256-95xitHnbFFaj0xPuLMWvIvuJzoCO3VSd592X1RI9h3A=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    tiktoken
  ];

  pythonImportsCheck = [ "tokentrim" ];

  # tests connect to openai
  doCheck = false;

  meta = with lib; {
    description = "Easily trim 'messages' arrays for use with GPTs";
    homepage = "https://github.com/KillianLucas/tokentrim";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
