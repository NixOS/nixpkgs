{ stdenv
, buildPythonPackage
, fetchPypi
, botocore
, bcdoc
, s3transfer
, six
, colorama
, docutils
, rsa
, pyyaml
, groff
, less
}:

let
  colorama_3_7 = colorama.overrideAttrs (old: rec {
    name = "${pname}-${version}";
    pname = "colorama";
    version = "0.3.7";
    src = old.src.override {
      inherit version;
      sha256 = "0avqkn6362v7k2kg3afb35g4sfdvixjgy890clip4q174p9whhz0";
    };
  });

in buildPythonPackage rec {
  pname = "awscli";
  version = "1.14.32";
  namePrefix = "";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09i82nf43pv5v598wvbj4nk1bfc64wp7xzlx5ykaca5m40lkarz0";
  };

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [
    botocore
    bcdoc
    s3transfer
    six
    colorama_3_7
    docutils
    rsa
    pyyaml
    groff
    less
  ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    echo "complete -C $out/bin/aws_completer aws" > $out/etc/bash_completion.d/awscli
    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions
    rm $out/bin/aws.cmd
  '';

  meta = with stdenv.lib; {
    homepage = https://aws.amazon.com/cli/;
    description = "Unified tool to manage your AWS services";
    license = stdenv.lib.licenses.asl20;
    maintainers = with maintainers; [ muflax ];
  };
}
