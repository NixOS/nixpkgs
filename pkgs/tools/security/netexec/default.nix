{ lib
, fetchFromGitHub
, python3
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      impacket = super.impacket.overridePythonAttrs {
        version = "0.12.0.dev1-unstable-2023-11-30";
        src = fetchFromGitHub {
          owner = "Pennyw0rth";
          repo = "impacket";
          rev = "d370e6359a410063b2c9c68f6572c3b5fb178a38";
          hash = "sha256-Jozn4lKAnLQ2I53+bx0mFY++OH5P4KyqVmrS5XJUY3E=";
        };
        # Fix version to be compliant with Python packaging rules
        postPatch = ''
          substituteInPlace setup.py \
            --replace 'version="{}.{}.{}.{}{}"' 'version="{}.{}.{}"'
        '';
      };
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "netexec";
  version = "1.1.0";
  pyproject = true;
  pythonRelaxDeps = true;
  # TODO: remove those once upstream merge this PR and release a new version:
  # https://github.com/Pennyw0rth/NetExec/pull/162
  pythonRemoveDeps = [
    # Upstream incorrectly includes the wrong package as dependency.
    # Should be `resource` from stdlib (https://docs.python.org/3/library/resource.html),
    # not `RussellLuo/resource` (a repo not maintained in 4 years)
    # See: https://github.com/Pennyw0rth/NetExec/commit/483dc69a2a7aa8f364adfc46096a8b5114c0a31a
    "resource"
    # Lint
    "ruff"
    # Windows only dependency
    "pyreadline"
    # Fail to detect dev version requirement
    "neo4j"
  ];

  src = fetchFromGitHub {
    owner = "Pennyw0rth";
    repo = "NetExec";
    rev = "refs/tags/v${version}";
    hash = "sha256-cNkZoIdfrKs5ZvHGKGBybCWGwA6C4rqjCOEM+pX70S8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '{ git = "https://github.com/Pennyw0rth/impacket.git", branch = "gkdi" }' '"*"'

    substituteInPlace pyproject.toml \
      --replace '{ git = "https://github.com/Pennyw0rth/oscrypto" }' '"*"'
  '';

  nativeBuildInputs = with python.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python.pkgs; [
    requests
    beautifulsoup4
    lsassy
    termcolor
    msgpack
    neo4j
    pylnk3
    pypsrp
    paramiko
    impacket
    dsinternals
    xmltodict
    terminaltables
    aioconsole
    pywerview
    minikerberos
    pypykatz
    aardwolf
    dploot
    bloodhound-py
    asyauth
    masky
    sqlalchemy
    aiosqlite
    pyasn1-modules
    rich
    python-libnmap
    oscrypto
  ];

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Network service exploitation tool (maintained fork of CrackMapExec)";
    homepage = "https://github.com/Pennyw0rth/NetExec";
    changelog = "https://github.com/Pennyw0rth/NetExec/releases/tag/v${version}";
    license = with licenses; [ bsd2 ];
    mainProgram = "nxc";
    maintainers = with maintainers; [ vncsb ];
  };
}
