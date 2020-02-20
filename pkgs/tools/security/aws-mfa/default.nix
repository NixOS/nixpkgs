{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "aws-mfa";
  version = "0.0.12";
  format = "wheel";

  src = python3Packages.fetchPypi {
    inherit version format;
    pname  = "aws_mfa";
    sha256 = "aef772e38734f1a50e618a2b19a8a69e5f0ced9cbeaf3be5132e9e1ba04fa294";
  };

  propagatedBuildInputs = with python3Packages; [ boto3 ];

  meta = with lib; {
    description = "Easily manage your AWS Security Credentials when using Multi-Factor Authentication";
    homepage = "https://github.com/broamski/aws-mfa";
    license = licenses.mit;
    maintainers = maintainers.pmyjavec;
  };
}
