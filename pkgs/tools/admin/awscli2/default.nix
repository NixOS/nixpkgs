{ lib
, stdenv
, python3
, groff
, less
, fetchFromGitHub
, fetchpatch
, installShellFiles
, nix-update-script
, testers
, awscli2
}:

let
  py = python3 // {
    pkgs = python3.pkgs.overrideScope (final: prev: {
      sphinx = prev.sphinx.overridePythonAttrs (prev: {
        disabledTests = prev.disabledTests ++ [
          "test_check_link_response_only" # fails on hydra https://hydra.nixos.org/build/242624087/nixlog/1
        ];
      });
      python-dateutil = prev.python-dateutil.overridePythonAttrs (prev: {
        version = "2.8.2";
        pyproject = null;
        src = prev.src.override {
          version = "2.8.2";
          hash = "sha256-ASPKzBYnrhnd88J6XeW9Z+5FhvvdZEDZdI+Ku0g9PoY=";
        };
        patches = [
          # https://github.com/dateutil/dateutil/pull/1285
          (fetchpatch {
            url = "https://github.com/dateutil/dateutil/commit/f2293200747fb03d56c6c5997bfebeabe703576f.patch";
            relative = "src";
            hash = "sha256-BVEFGV/WGUz9H/8q+l62jnyN9VDnoSR71DdL+LIkb0o=";
          })
        ];
        postPatch = null;
      });
      ruamel-yaml = prev.ruamel-yaml.overridePythonAttrs (prev: {
        src = prev.src.override {
          version = "0.17.21";
          hash = "sha256-i3zml6LyEnUqNcGsQURx3BbEJMlXO+SSa1b/P10jt68=";
        };
      });
      urllib3 = prev.urllib3.overridePythonAttrs (prev: rec {
        pyproject = true;
        version = "1.26.18";
        nativeBuildInputs = with final; [
          setuptools
        ];
        src = prev.src.override {
          inherit version;
          hash = "sha256-+OzBu6VmdBNFfFKauVW/jGe0XbeZ0VkGYmFxnjKFgKA=";
        };
      });
    });
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli2";
  version = "2.15.32"; # N.B: if you change this, check if overrides are still up-to-date
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-EdS8nsSlFtCvHn6Aysj8C5tmdBBRUtbTEVqkYex5vgc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'awscrt>=0.19.18,<=0.19.19' 'awscrt>=0.19.18' \
      --replace-fail 'cryptography>=3.3.2,<40.0.2' 'cryptography>=3.3.2' \
      --replace-fail 'distro>=1.5.0,<1.9.0' 'distro>=1.5.0' \
      --replace-fail 'docutils>=0.10,<0.20' 'docutils>=0.10' \
      --replace-fail 'prompt-toolkit>=3.0.24,<3.0.39' 'prompt-toolkit>=3.0.24'

    substituteInPlace requirements-base.txt \
      --replace-fail "wheel==0.38.4" "wheel>=0.38.4"

    # Upstream needs pip to build and install dependencies and validates this
    # with a configure script, but we don't as we provide all of the packages
    # through PYTHONPATH
    sed -i '/pip>=/d' requirements/bootstrap.txt
  '';

  build-system = [
    installShellFiles
    flit-core
  ];

  dependencies = [
    awscrt
    bcdoc
    botocore
    colorama
    cryptography
    distro
    docutils
    groff
    jmespath
    less
    prompt-toolkit
    python-dateutil
    pyyaml
    ruamel-yaml
    urllib3
  ];

  nativeCheckInputs = [
    jsonschema
    mock
    pytestCheckHook
  ];

  postInstall = ''
    installShellCompletion --cmd aws \
      --bash <(echo "complete -C $out/bin/aws_completer aws") \
      --zsh $out/bin/aws_zsh_completer.sh
  '' + lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    rm $out/bin/aws.cmd
  '';

  preCheck = ''
    export PATH=$PATH:$out/bin
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    "tests/dependencies"
    "tests/unit/botocore"

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
      inherit version;
    };
  };

  meta = with lib; {
    description = "Unified tool to manage your AWS services";
    homepage = "https://aws.amazon.com/cli/";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple davegallant bryanasdev000 devusb anthonyroussel ];
    mainProgram = "aws";
  };
}
