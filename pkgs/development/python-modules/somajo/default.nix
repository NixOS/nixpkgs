{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  regex,
}:

buildPythonPackage rec {
  pname = "somajo";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = "SoMaJo";
    tag = "v${version}";
    hash = "sha256-fq891LX6PukUEfrXplulhnisuPX/RqLAQ/5ty/Fvm9k=";
  };

  build-system = [ setuptools ];

  dependencies = [ regex ];

  # loops forever
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "somajo" ];

  meta = {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    changelog = "https://github.com/tsproisl/SoMaJo/blob/v${version}/CHANGES.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "somajo-tokenizer";
  };
}
