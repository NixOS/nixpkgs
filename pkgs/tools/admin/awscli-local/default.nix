{ lib
, buildPythonApplication
, fetchPypi
, python3Packages
, awscli2
, substituteAll
}:

buildPythonApplication rec {
  pname = "awscli-local";
  version = "0.20";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hpREX0/PEeHtFcDPRxULhfWQTMbyeugVcEO4nPn0sWo=";
  };

  propagatedBuildInputs = with python3Packages; [
    localstack-client
  ];

  patches = [
    # hardcode paths to aws in awscli2 package
    (substituteAll {
      src = ./fix-paths.patch;
      aws = "${awscli2}/bin/aws";
    })
  ];

  checkPhase = ''
    $out/bin/awslocal -h
    $out/bin/awslocal --version
  '';

  meta = with lib; {
    description = "Thin wrapper around the AWS command line interface for use with LocalStack";
    license = licenses.apsl20;
    maintainers = with maintainers; [ anthonyroussel ];
    homepage = "https://github.com/localstack/awscli-local";
  };
}
