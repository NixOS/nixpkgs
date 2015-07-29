{ stdenv, fetchzip, pythonPackages, groff }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.7.41";
  namePrefix = "";

  src = fetchzip {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "1xfvpqyxi5qaqcvm56q616k9zjidbc9l2vk1v3ld6lnlzri3a1ra";
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
