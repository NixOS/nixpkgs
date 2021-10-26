{ lib
, python3Packages
}:

with python3Packages; buildPythonApplication rec {
  pname = "synadm";
  version = "0.31";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1098a5248a1e2de53ced3c699b3b78ced3327c5f4e0ff092a95ef4940e4f9c6e";
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
