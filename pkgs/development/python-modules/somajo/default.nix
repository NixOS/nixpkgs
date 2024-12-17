{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  regex,
}:

buildPythonPackage rec {
  pname = "somajo";
  version = "2.4.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = "SoMaJo";
    rev = "refs/tags/v${version}";
    hash = "sha256-fq891LX6PukUEfrXplulhnisuPX/RqLAQ/5ty/Fvm9k=";
  };

  build-system = [ setuptools ];

  dependencies = [ regex ];

  # loops forever
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "somajo" ];

  meta = with lib; {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    changelog = "https://github.com/tsproisl/SoMaJo/blob/v${version}/CHANGES.txt";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "somajo-tokenizer";
  };
}
