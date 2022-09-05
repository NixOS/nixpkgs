{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "crackmapexec";
  version = "5.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "byt3bl33d3r";
    repo = "CrackMapExec";
    rev = "v${version}";
    hash = "sha256-wPS1PCvR9Ffp0r9lZZkFATt+i+eR5ap16HzLWDZbJKI=";
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
    msgpack
    neo4j
    paramiko
    pylnk3
    pypsrp
    pywerview
    requests
    requests_ntlm
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
    homepage = "https://github.com/byt3bl33d3r/CrackMapExec";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "cme";
  };
}
