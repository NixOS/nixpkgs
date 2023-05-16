{ lib
, python3
, groff
, less
, fetchFromGitHub
, nix-update-script
, testers
, awscli2
}:

let
  py = python3 // {
<<<<<<< HEAD
    pkgs = python3.pkgs.overrideScope (final: prev: {
      ruamel-yaml = prev.ruamel-yaml.overridePythonAttrs (prev: {
        src = prev.src.override {
          version = "0.17.21";
          hash = "sha256-i3zml6LyEnUqNcGsQURx3BbEJMlXO+SSa1b/P10jt68=";
        };
      });
=======
    pkgs = python3.pkgs.overrideScope (self: super: {
      # nothing right now
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    });
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli2";
<<<<<<< HEAD
  version = "2.13.15"; # N.B: if you change this, check if overrides are still up-to-date
=======
  version = "2.11.15"; # N.B: if you change this, check if overrides are still up-to-date
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-wxuuEya2uUquRmRmh9M2wJ6dcvCx8kyzk71og9OAJ+c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'cryptography>=3.3.2,<40.0.2' 'cryptography>=3.3.2' \
      --replace 'flit_core>=3.7.1,<3.8.1' 'flit_core>=3.7.1' \
      --replace 'awscrt>=0.16.4,<=0.16.16' 'awscrt>=0.16.4'

    substituteInPlace requirements-base.txt \
      --replace "wheel==0.38.4" "wheel>=0.38.4" \
      --replace "flit_core==3.8.0" "flit_core>=3.8.0"

    # Upstream needs pip to build and install dependencies and validates this
    # with a configure script, but we don't as we provide all of the packages
    # through PYTHONPATH
    sed -i '/pip>=/d' requirements/bootstrap.txt
=======
    rev = version;
    hash = "sha256-2FE5PJxdTqSrAIgkaZPf91B6bI6Bj9tbJjXg2nAaLdo=";
  };

  postPatch = ''
    substituteInPlace requirements/bootstrap.txt \
      --replace "pip>=22.0.0,<23.0.0" "pip>=22.0.0,<24.0.0"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    awscrt
    bcdoc
<<<<<<< HEAD
    botocore
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    colorama
    cryptography
    distro
    docutils
    groff
<<<<<<< HEAD
    jmespath
    less
    prompt-toolkit
    python-dateutil
    pyyaml
    ruamel-yaml
=======
    less
    prompt-toolkit
    pyyaml
    rsa
    ruamel-yaml
    python-dateutil
    jmespath
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    urllib3
  ];

  nativeCheckInputs = [
    jsonschema
    mock
    pytestCheckHook
  ];

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/awscli/data
    ${python3.interpreter} scripts/gen-ac-index --index-location $out/${python3.sitePackages}/awscli/data/ac.index

    mkdir -p $out/share/bash-completion/completions
    echo "complete -C $out/bin/aws_completer aws" > $out/share/bash-completion/completions/aws

    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions

    rm $out/bin/aws.cmd
  '';

<<<<<<< HEAD
=======
  doCheck = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = ''
    export PATH=$PATH:$out/bin
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/backends"
    "tests/functional"
  ];

  pythonImportsCheck = [
    "awscli"
  ];

  passthru = {
    python = py; # for aws_shell
    updateScript = nix-update-script {
      # Excludes 1.x versions from the Github tags list
      extraArgs = [ "--version-regex" "^(2\.(.*))" ];
    };
    tests.version = testers.testVersion {
      package = awscli2;
      command = "aws --version";
<<<<<<< HEAD
      inherit version;
=======
      version = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  meta = with lib; {
<<<<<<< HEAD
    description = "Unified tool to manage your AWS services";
    homepage = "https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
=======
    homepage = "https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple davegallant bryanasdev000 devusb anthonyroussel ];
    mainProgram = "aws";
  };
}
