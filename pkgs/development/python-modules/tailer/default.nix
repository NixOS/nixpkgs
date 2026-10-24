{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:

buildPythonPackage rec {
  pname = "tailer";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "six8";
    repo = "pytailer";
    rev = version;
    hash = "sha256-vnDhT8hNGQd58+FxTILMQP8OhOuMl85BDfnMhEctt+g=";
  };

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m doctest -v src/tailer/__init__.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "tailer" ];

  meta = {
    description = "Python implementation implementation of GNU tail and head";
    mainProgram = "pytail";
    homepage = "https://github.com/six8/pytailer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
