{ lib
, stdenv
, fetchFromGitHub
, python3
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
  version = "1.1.0-unstable-2024-01-15";
  pyproject = true;
  pythonRelaxDeps = true;
  pythonRemoveDeps = [
    # Fail to detect dev version requirement
    "neo4j"
  ];

  src = fetchFromGitHub {
    owner = "Pennyw0rth";
    repo = "NetExec";
    rev = "9df72e2f68b914dfdbd75b095dd8f577e992615f";
    hash = "sha256-oQHtTE5hdlxHX4uc412VfNUrN0UHVbwI0Mm9kmJpNW4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '{ git = "https://github.com/Pennyw0rth/impacket.git", branch = "gkdi" }' '"*"' \
      --replace '{ git = "https://github.com/Pennyw0rth/oscrypto" }' '"*"'
  '';

  nativeBuildInputs = with python.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python.pkgs; [
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
    neo4j
    oscrypto
    paramiko
    pyasn1-modules
    pylnk3
    pypsrp
    pypykatz
    python-libnmap
    pywerview
    requests
    rich
    sqlalchemy
    termcolor
    terminaltables
    xmltodict
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
    # FIXME: failing fixupPhase:
    # $ Rewriting #!/nix/store/<hash>-python3-3.11.7/bin/python3.11 to #!/nix/store/<hash>-python3-3.11.7
    # $ /nix/store/<hash>-wrap-python-hook/nix-support/setup-hook: line 65: 47758 Killed: 9               sed -i "$f" -e "1 s^#!/nix/store/<hash>-python3-3.11.7^#!/nix/store/<hash>-python3-3.11.7^"
    broken = stdenv.hostPlatform.isDarwin;
  };
}
