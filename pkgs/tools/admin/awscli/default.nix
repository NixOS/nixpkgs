{ stdenv, fetchFromGitHub, pythonPackages, groff }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.7.44";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = "42389bdca10b2bd708585d46a2a8a4e51b5f7ce7";
    sha256 = "0p7s7kqpiki02m2vzwjsnkzms5smwsa6ipgnjab8sb6ihfd7ib3n";
  };

  propagatedBuildInputs = [
    pythonPackages.botocore
    pythonPackages.bcdoc
    pythonPackages.six
    pythonPackages.colorama
    pythonPackages.docutils
    pythonPackages.rsa
    pythonPackages.pyasn1
    groff
  ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    echo "complete -C $out/bin/aws_completer aws" > $out/etc/bash_completion.d/awscli
    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions
    rm $out/bin/aws.cmd
  '';

  meta = {
    homepage = https://aws.amazon.com/cli/;
    description = "Unified tool to manage your AWS services";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ muflax ];
  };
}
