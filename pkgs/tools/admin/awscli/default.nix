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
  version = "1.14.41";
  namePrefix = "";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cf2a52d56f26e22e2fbd7b72649ef1d3de8930df7a730d7f27418d129bb3a6a";
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
