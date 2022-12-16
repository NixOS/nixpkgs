{ lib
, python3
# , groff
# , less
# , nix-update-script
# , testers
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      fido2 = super.fido2.overridePythonAttrs (oldAttrs: rec {
        version = "0.9.3";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-tF6JphCc/Lfxu1E3dqotZAjpXEgi+DolORi5RAg0Zuw=";
        };
      });

      # awscrt = super.awscrt.overridePythonAttrs (oldAttrs: rec {
      #   version = "0.14.0";
      #   src = self.fetchPypi {
      #     inherit (oldAttrs) pname;
      #     inherit version;
      #     hash = "sha256-MGLTFcsWVC/gTdgjny6LwyOO6QRc1QcLkVzy677Lqqw=";
      #   };
      # });

      # prompt-toolkit = super.prompt-toolkit.overridePythonAttrs (oldAttrs: rec {
      #   version = "3.0.28";
      #   src = self.fetchPypi {
      #     pname = "prompt_toolkit";
      #     inherit version;
      #     hash = "sha256-nxzRax6GwpaPJRnX+zHdnWaZFvUVYSwmnRTp7VK1FlA=";
      #   };
      # });
    };
  };

  # py = python3;
in
with py.pkgs; buildPythonApplication rec {
  pname = "gimme-aws-creds";
  version = "2.4.4"; # N.B: if you change this, check if overrides are still up-to-date
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "gimme_aws_creds";
    hash = "sha256-twD/hb1kPBKegNLifdH1Kk6f8Cf0bsvP/tkQNTccSEg=";
  };

  nativeBuildInputs = [
    # flit-core
  ];

  propagatedBuildInputs = [
    boto3
    python-dateutil
    fido2
    beautifulsoup4
    # awscrt
    # bcdoc
    # colorama
    # cryptography
    # distro
    # docutils
    # groff
    # less
    # prompt-toolkit
    # pyyaml
    # rsa
    # ruamel-yaml
    # python-dateutil
    # jmespath
    # urllib3
  ];

  checkInputs = [
    # jsonschema
    # mock
    # pytestCheckHook
  ];

  # postPatch = ''
  #   substituteInPlace pyproject.toml \
  #     --replace "colorama>=0.2.5,<0.4.4" "colorama" \
  #     --replace "distro>=1.5.0,<1.6.0" "distro" \
  #     --replace "cryptography>=3.3.2,<=38.0.1" "cryptography>=3.3.2,<=38.0.3"
  # '';

  # postInstall = ''
  #   mkdir -p $out/${python3.sitePackages}/awscli/data
  #   ${python3.interpreter} scripts/gen-ac-index --index-location $out/${python3.sitePackages}/awscli/data/ac.index

  #   mkdir -p $out/share/bash-completion/completions
  #   echo "complete -C $out/bin/aws_completer aws" > $out/share/bash-completion/completions/aws

  #   mkdir -p $out/share/zsh/site-functions
  #   mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions

  #   rm $out/bin/aws.cmd
  # '';

  # doCheck = true;

  # preCheck = ''
  #   export PATH=$PATH:$out/bin
  #   export HOME=$(mktemp -d)
  # '';

  # pytestFlagsArray = [
  #   "-Wignore::DeprecationWarning"
  # ];

  # disabledTestPaths = [
  #   # Integration tests require networking
  #   "tests/integration"

  #   # Disable slow tests (only run unit tests)
  #   "tests/backends"
  #   "tests/functional"
  # ];

  # pythonImportsCheck = [
  #   "awscli"
  # ];

  # passthru = {
  #   python = py; # for aws_shell
  #   updateScript = nix-update-script {
  #     attrPath = pname;
  #   };
  #   tests.version = testers.testVersion {
  #     package = awscli2;
  #     command = "aws --version";
  #     version = version;
  #   };
  # };

  meta = with lib; {
    homepage = "https://github.com/Nike-Inc/gimme-aws-creds";
    changelog = "https://github.com/Nike-Inc/gimme-aws-creds/releases";
    description = "A CLI that utilizes Okta IdP via SAML to acquire temporary AWS credentials";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple davegallant bryanasdev000 devusb anthonyroussel ];
    mainProgram = "gimme-aws-creds";
  };
}
