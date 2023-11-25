{ lib
, python3
, fetchFromGitHub
, universal-ctags
, portaudio
}:
let
  version = "0.14.2";
in
python3.pkgs.buildPythonApplication rec {
  pname = "aider";
  format = "setuptools";
  inherit version;

  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "v${version}";
    hash = "sha256-JDhpIMgA4Fa68XnuYdH0oSo5vswtwzOs5AeT46PVQbc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    universal-ctags
    aiohttp
    aiosignal
    async-timeout
    attrs
    backoff
    certifi
    charset-normalizer
    configargparse
    diskcache
    frozenlist
    gitdb
    gitpython
    idna
    jsonschema
    markdown-it-py
    mdurl
    multidict
    networkx
    numpy
    openai
    packaging
    prompt-toolkit
    pygments
    pyyaml
    requests
    rich
    scipy
    smmap
    sounddevice
    soundfile
    tiktoken
    tqdm
    urllib3
    wcwidth
    yarl
  ] ++ [
    portaudio
    universal-ctags
  ];

  postPatch = ''
    substituteInPlace aider/repomap.py \
      --replace '"ctags"' '"${universal-ctags}/bin/ctags"'
  '';

  # Tests require a Git repository
  doCheck = false;

  pythonImportsCheck = [
    "aider"
  ];

  meta = with lib; {
    changelog = "https://github.com/paul-gauthier/aider/raw/v${version}/HISTORY.md";
    description = "AI pair programming in your terminal";
    homepage = "https://github.com/paul-gauthier/aider";
    license = licenses.asl20;
    maintainers = with maintainers; [ nwjsmith ];
  };
}
