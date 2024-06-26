{
  lib,
  buildPythonPackage,
  dateutils,
  fetchFromGitHub,
  poetry-core,
  pyaml,
  pythonOlder,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "thelogrus";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "thelogrus";
    rev = "refs/tags/v${version}";
    hash = "sha256-96/EjDh5XcTsfUcTnsltsT6LMYbyKuM/eNyeq2Pukfo=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "pyaml" ];

  propagatedBuildInputs = [
    dateutils
    pyaml
  ];

  # Module has no unit tests
  doCheck = false;

  pythonImportsCheck = [ "thelogrus" ];

  meta = with lib; {
    description = "Python 3 version of logrus";
    mainProgram = "human-time";
    homepage = "https://github.com/unixorn/thelogrus";
    changelog = "https://github.com/unixorn/thelogrus/blob/${version}/ChangeLog.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
