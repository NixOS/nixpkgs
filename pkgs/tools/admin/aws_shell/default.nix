{ stdenv
, awscli
}:

with awscli.python.pkgs;

buildPythonPackage rec {
  pname = "aws-shell";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2044b0ef78c7542c392f2cee4b74a4439545c63dda0a3e28b712fff53e8e5823";
  };

  # Why does it propagate packages that are used for testing?
  propagatedBuildInputs = [
    awscli
    prompt_toolkit
    boto3
    configobj
    pygments
    pyyaml
  ];

  postPatch = ''
    substituteInPlace setup.py \
     --replace "prompt-toolkit>=1.0.0,<1.1.0" "prompt-toolkit"
  '';

  #Checks are failing due to missing TTY, which won't exist.
  doCheck = false;
  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/awslabs/aws-shell;
    description = "An integrated shell for working with the AWS CLI";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
