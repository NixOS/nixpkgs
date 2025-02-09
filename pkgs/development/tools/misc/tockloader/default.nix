{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tockloader";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7W55jugVtamFUL8N3dD1LFLJP2UDQb74V6o96rd/tEg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    argcomplete
    colorama
    crcmod
    pycryptodome
    pyserial
    questionary
    toml
    tqdm
  ];

  # Project has no test suite
  checkPhase = ''
    runHook preCheck
    $out/bin/tockloader --version | grep -q ${version}
    runHook postCheck
  '';

  meta = with lib; {
    description = "Tool for programming Tock onto hardware boards";
    homepage = "https://github.com/tock/tockloader";
    changelog = "https://github.com/tock/tockloader/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

