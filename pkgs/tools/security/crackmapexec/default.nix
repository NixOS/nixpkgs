{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "crackmapexec";
  version = "5.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Porchetta-Industries";
    repo = "CrackMapExec";
    rev = "refs/tags/v${version}";
    hash = "sha256-V2n840QyLofTfQE4vtFYGfQwl65sklp+KfNS9RCLvI8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aioconsole
    aardwolf
    beautifulsoup4
    dsinternals
    impacket
    lsassy
    masky
    msgpack
    neo4j
    paramiko
    pylnk3
    pypsrp
    pywerview
    requests
    requests-ntlm
    termcolor
    terminaltables
    xmltodict
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '{ git = "https://github.com/mpgn/impacket.git", branch = "master" }' '"x"'
  '';

  pythonRelaxDeps = true;

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "cme"
  ];

  meta = with lib; {
    description = "Tool for pentesting networks";
    homepage = "https://github.com/Porchetta-Industries/CrackMapExec";
    changelog = "https://github.com/Porchetta-Industries/CrackMapExec/releases/tag/v${version}";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "cme";
  };
}
