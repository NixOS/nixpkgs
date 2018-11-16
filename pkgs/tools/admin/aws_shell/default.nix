{ stdenv
, buildPythonPackage
, fetchPypi
, awscli
, prompt_toolkit
, boto3
, configobj
, pygments
}:

buildPythonPackage rec {
  pname = "aws-shell";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b46a673b81254e5e014297e08c9ecab535773aa651ca33dc3786a1fd612f9810";
  };

  # Why does it propagate packages that are used for testing?
  propagatedBuildInputs = [
    awscli
    prompt_toolkit
    boto3
    configobj
    pygments
  ];

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
