{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
let
  python = python3.override {
    self = python;
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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Pennyw0rth";
    repo = "NetExec";
    tag = "v${version}";
    hash = "sha256-Pub7PAw6CTN4c/PHTPE9KcnDR2a6hSza1ODp3EWMOH0=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # Fail to detect dev version requirement
    "neo4j"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '{ git = "https://github.com/fortra/impacket.git" }' '"*"' \
      --replace-fail '{ git = "https://github.com/Pennyw0rth/NfsClient" }' '"*"'
  '';

  build-system = with python.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python.pkgs; [
    aardwolf
    aioconsole
    aiosqlite
    argcomplete
    asyauth
    beautifulsoup4
    bloodhound-py
    dploot
    dsinternals
    impacket
    lsassy
    masky
    minikerberos
    msgpack
    msldap
    neo4j
    paramiko
    pyasn1-modules
    pylnk3
    pynfsclient
    pypsrp
    pypykatz
    python-dateutil
    python-libnmap
    pywerview
    requests
    rich
    sqlalchemy
    termcolor
    terminaltables
    xmltodict
  ];

  nativeCheckInputs = with python.pkgs; [ pytestCheckHook ];

  # Tests no longer works out-of-box with 1.3.0
  doCheck = false;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Network service exploitation tool (maintained fork of CrackMapExec)";
    homepage = "https://github.com/Pennyw0rth/NetExec";
    changelog = "https://github.com/Pennyw0rth/NetExec/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vncsb ];
    mainProgram = "nxc";
    # FIXME: failing fixupPhase:
    # $ Rewriting #!/nix/store/<hash>-python3-3.11.7/bin/python3.11 to #!/nix/store/<hash>-python3-3.11.7
    # $ /nix/store/<hash>-wrap-python-hook/nix-support/setup-hook: line 65: 47758 Killed: 9               sed -i "$f" -e "1 s^#!/nix/store/<hash>-python3-3.11.7^#!/nix/store/<hash>-python3-3.11.7^"
    broken = stdenv.hostPlatform.isDarwin;
  };
}
