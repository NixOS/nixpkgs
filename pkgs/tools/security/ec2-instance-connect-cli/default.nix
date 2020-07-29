{ buildPythonPackage, fetchPypi, lib, botocore }:

buildPythonPackage rec {
  pname = "ec2-instance-connect-cli";
  version = "1.0.0";

  src = fetchPypi {
    pname = "ec2instanceconnectcli";
    inherit version;
    sha256 = "1s4xya5ddlv9vbbn62lhcspl4g1fjqhh5nq2snbmliqssmw8r0fw";
  };

  propagatedBuildInputs = [ botocore ];

  postInstall = ''
    rm -v $out/bin/*.cmd
  '';

  meta = {
    homepage = https://aws.amazon.com/cli/;
    description = "An all-in-one client for EC2 Instance Connect that handles key brokerage and establishing connection to EC2 Instances";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thefloweringash ];
  };
}
