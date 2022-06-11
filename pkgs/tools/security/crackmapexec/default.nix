{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "crackmapexec";
  version = "5.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "byt3bl33d3r";
    repo = "CrackMapExec";
    rev = "v${version}";
    hash = "sha256-IgD8RjwVEoEXmnHU3DR3wzUdJDWIbFw9sES5qYg30a8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aioconsole
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

  patches = [
    # Switch to poetry-core, https://github.com/byt3bl33d3r/CrackMapExec/pull/580
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/byt3bl33d3r/CrackMapExec/commit/e5c6c2b5c7110035b34ea7a080defa6d42d21dd4.patch";
      hash = "sha256-5SpoQD+uSYLM6Rdq0/NTbyEv4RsBUuawNNsknS71I9M=";
    })
  ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "bs4"
  ];

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
