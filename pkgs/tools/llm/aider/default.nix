{ lib
, python3
, fetchFromGitHub
, portaudio
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aider";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "v${version}";
    sha256 = "sha256-OD2xGQvYFyiAnkRtb0VczGLvgWmW45n0HzdHoLLMdHY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    backoff
    beautifulsoup4
    configargparse
    diff-match-patch
    diskcache
    flake8
    gitpython
    google-generativeai
    grep-ast
    grep-ast
    jsonschema
    litellm
    networkx
    numpy
    openai
    packaging
    pathspec
    pillow
    playwright
    prompt-toolkit
    pypandoc
    pyyaml
    rich
    scipy
    sounddevice
    soundfile
    streamlit
    tiktoken
    watchdog
  ] ++ [
    portaudio
  ];

  doCheck = false;

  meta = with lib; {
    description = "aider is AI pair programming in your terminal";
    homepage = "https://github.com/paul-gauthier/aider";
    license = licenses.asl20;
    maintainers = with maintainers; [ taha-yassine ];
  };
}
