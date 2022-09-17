{ lib
, python3
, groff
, less
, fetchFromGitHub
}:
let
  py = python3.override {
    packageOverrides = self: super: {
      awscrt = super.awscrt.overridePythonAttrs (oldAttrs: rec {
        version = "0.13.11";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-Yx3I3RD57Nx6Cvm4moc5zmMbdsHeYiMghDfbQUor38E=";
        };
      });
      jmespath = super.jmespath.overridePythonAttrs (oldAttrs: rec {
        version = "0.10.0";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-uF0FZ7hmYUmpMXJxLmiSBzQzPAzn6Jt4s+mH9x5e1Pk=";
        };
      });
    };
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli2";
  version = "2.7.14"; # N.B: if you change this, check if overrides are still up-to-date

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    sha256 = "sha256-ji/hKoYxM3wag9DXy2e/VsJZVGN5UEebWX/ctOVJ42M=";
  };

  propagatedBuildInputs = [
    awscrt
    bcdoc
    colorama
    cryptography
    distro
    docutils
    groff
    less
    prompt-toolkit
    pyyaml
    rsa
    ruamel-yaml
    wcwidth
    python-dateutil
    jmespath
    urllib3
  ];

  checkInputs = [
    jsonschema
    mock
    pytestCheckHook
    pytest-xdist
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "colorama>=0.2.5,<0.4.4" "colorama" \
      --replace "cryptography>=3.3.2,<37.0.0" "cryptography" \
      --replace "docutils>=0.10,<0.16" "docutils" \
      --replace "ruamel.yaml>=0.15.0,<0.16.0" "ruamel.yaml" \
      --replace "wcwidth<0.2.0" "wcwidth" \
      --replace "distro>=1.5.0,<1.6.0" "distro"
  '';

  checkPhase = ''
    export PATH=$PATH:$out/bin

    # https://github.com/NixOS/nixpkgs/issues/16144#issuecomment-225422439
    export HOME=$TMP
  '';

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/awscli/data
    ${python3.interpreter} scripts/gen-ac-index --index-location $out/${python3.sitePackages}/awscli/data/ac.index

    mkdir -p $out/share/bash-completion/completions
    echo "complete -C $out/bin/aws_completer aws" > $out/share/bash-completion/completions/aws

    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions

    rm $out/bin/aws.cmd
  '';

  passthru.python = py; # for aws_shell

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple davegallant bryanasdev000 devusb ];
  };
}
