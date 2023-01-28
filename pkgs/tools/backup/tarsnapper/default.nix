{ lib
, python3Packages
, fetchFromGitHub
, tarsnap
}:

python3Packages.buildPythonApplication rec {
  pname = "tarsnapper";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "miracle2k";
    repo = pname;
    rev = version;
    sha256 = "03db49188f4v1946c8mqqj30ah10x68hbg3a58js0syai32v12pm";
  };

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    python-dateutil
    pexpect
  ];

  nativeCheckInputs = with python3Packages; [
    nose
  ];

  patches = [
    # Remove standard module argparse from requirements
    ./remove-argparse.patch
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ tarsnap ]}" ];

  checkPhase = ''
    runHook preCheck
    nosetests tests
    runHook postCheck
  '';

  pythonImportsCheck = [ "tarsnapper" ];

  meta = with lib; {
    description = "Wrapper which expires backups using a gfs-scheme";
    homepage = "https://github.com/miracle2k/tarsnapper";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
