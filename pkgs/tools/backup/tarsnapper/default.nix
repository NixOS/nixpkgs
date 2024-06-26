{ lib
, python3Packages
, fetchFromGitHub
, fetchpatch
, tarsnap
}:

python3Packages.buildPythonApplication rec {
  pname = "tarsnapper";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miracle2k";
    repo = pname;
    rev = version;
    hash = "sha256-5i9eum9hbh6VFhvEIDq5Uapy6JtIbf9jZHhRYZVoC1w=";
  };

  patches = [
    # Fix failing tests when default_deltas is None
    (fetchpatch {
      url = "https://github.com/miracle2k/tarsnapper/commit/2ee33ce748b9bb42d559cc2c0104115732cb4150.patch";
      hash = "sha256-fEXGhzlfB+J5lw1pcsC5Ne7I8UMnDzwyyCx/zm15+fU=";
    })
  ];

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    python-dateutil
    pexpect
  ];

  nativeCheckInputs = with python3Packages; [
    pynose
  ];

  # Remove standard module argparse from requirements
  pythonRemoveDeps = [ "argparse" ];

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
    maintainers = with maintainers; [ gmacon ];
    mainProgram = "tarsnapper";
  };
}
