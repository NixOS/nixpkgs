{ fetchPypi, python3, lib }:

python3.pkgs.buildPythonPackage rec {
  pname = "revChatGPT";
  version = "2.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UpuAZBX2I34OeigMMm9Tv5lIuOT5W+lgXU3ylfnbWAU=";
  };

  checkPhase = "echo 'No tests'";

  buildInputs = [ python3.pkgs.setuptools ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    openaiauth
  ];

  meta = with lib; {
    description = "A conversational chatbot built using GPT models from Hugging Face Transformers.";
    homepage = "https://github.com/realsnick/revchatgpt";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
  };
}
