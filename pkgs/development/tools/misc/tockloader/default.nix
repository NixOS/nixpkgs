{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "tockloader";
  version = "1.6.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1aqkj1nplcw3gmklrhq6vxy6v9ad5mqiw4y1svasak2zkqdk1wyc";
  };

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    colorama
    crcmod
    pyserial
    pytoml
    tqdm
  ];

  # has no test suite
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

