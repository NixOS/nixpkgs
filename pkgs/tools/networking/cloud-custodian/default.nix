{ lib, buildPythonApplication, fetchPypi
, argcomplete
, boto3
, botocore
, certifi
, python-dateutil
, jsonpatch
, jsonschema
, pyyaml
, tabulate
, urllib3
}:

buildPythonApplication rec {
  pname = "cloud-custodian";
  version = "0.8.45.1";

  src = fetchPypi {
    pname = "c7n";
    inherit version;
    sha256 = "0c199gdmpm83xfghrbzp02xliyxiygsnx2fvb35j9qpf37wzzp3z";
  };

  propagatedBuildInputs = [
    argcomplete
    boto3
    botocore
    certifi
    python-dateutil
    jsonpatch
    jsonschema
    pyyaml
    tabulate
    urllib3
  ];

  # Requires tox, many packages, and network access
  checkPhase = ''
    $out/bin/custodian --help
  '';

  meta = with lib; {
    description = "Rules engine for cloud security, cost optimization, and governance";
    mainProgram = "custodian";
    homepage = "https://cloudcustodian.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple ];
  };
}
