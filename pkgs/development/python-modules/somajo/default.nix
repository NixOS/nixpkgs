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

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = "SoMaJo";
    rev = "refs/tags/v${version}";
    hash = "sha256-fq891LX6PukUEfrXplulhnisuPX/RqLAQ/5ty/Fvm9k=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ regex ];

  # loops forever
  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [ "somajo" ];

  meta = with lib; {
    description = "Tokenizer and sentence splitter for German and English web texts";
    mainProgram = "somajo-tokenizer";
    homepage = "https://github.com/tsproisl/SoMaJo";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
