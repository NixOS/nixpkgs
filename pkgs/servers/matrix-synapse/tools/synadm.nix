{ lib
, python3Packages
}:

with python3Packages; buildPythonApplication rec {
  pname = "synadm";
  version = "0.34";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pM1nY8j7W1aeWv7/H+9Sz9jo4u1sax/fuKPtx0JKtL8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "Click>=7.0,<8.0" "Click"
  '';

  propagatedBuildInputs = [
    click
    click-option-group
    tabulate
    pyyaml
    requests
  ];

  checkPhase = ''
    runHook preCheck
    export HOME=$TMPDIR
    $out/bin/synadm -h > /dev/null
    runHook postCheck
  '';

  meta = with lib; {
    description = "Command line admin tool for Synapse";
    longDescription = ''
      A CLI tool to help admins of Matrix Synapse homeservers
      conveniently issue commands available via its admin API's
      (matrix-org/synapse@master/docs/admin_api)
    '';
    homepage = "https://github.com/JOJ0/synadm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
