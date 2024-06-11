{ lib
, python3
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudsmith-cli";
  version = "1.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cloudsmith-io";
    repo = "cloudsmith-cli";
    rev = "v${version}";
    hash = "sha256-a4hLx+INdFq6Ux3XkI5GWgAiGLHCoDA+MP2FNY3E6WA=";
  };

  patches = [
    # Fix compatibility with urllib3 2.0
    (fetchpatch {
      url = "https://github.com/cloudsmith-io/cloudsmith-cli/commit/1a8d2d91c01320537b26778003735d6b694141c2.patch";
      revert = true;
      includes = [
        "cloudsmith_cli/core/rest.py"
      ];
      hash = "sha256-Rf3MMJuLr8fzkRqSftIJ1eUbgNdfrng2V609jYvpogc=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    pip
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    click-configfile
    click-didyoumean
    click-spinner
    cloudsmith-api
    colorama
    future
    requests
    requests-toolbelt
    semver
    simplejson
    six
    setuptools # needs pkg_resources
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-cov
  ];

  checkInputs = with python3.pkgs; [
    httpretty
  ];

  pythonImportsCheck = [
    "cloudsmith_cli"
  ];

  postPatch = ''
    # Permit urllib3 2.0
    substituteInPlace setup.py \
      --replace-fail 'urllib3<2.0' 'urllib3'
  '';

  preCheck = ''
    # E   _pytest.pathlib.ImportPathMismatchError: ('cloudsmith_cli.cli.tests.conftest', '/build/source/build/lib/cloudsmith_cli/cli/tests/conftest.py', PosixPath('/build/source/cloudsmith_cli/cli/tests/conftest.py'))
    # ___________ ERROR collecting cloudsmith_cli/core/tests/test_init.py ____________
    # import file mismatch:
    # imported module 'cloudsmith_cli.core.tests.test_init' has this __file__ attribute:
    #   /build/source/build/lib/cloudsmith_cli/core/tests/test_init.py
    # which is not the same as the test file we want to collect:
    #   /build/source/cloudsmith_cli/core/tests/test_init.py
    # HINT: remove __pycache__ / .pyc files and/or use a unique basename for your test file modules
    # https://github.com/NixOS/nixpkgs/issues/255262
    cd "$out"
  '';

  meta = with lib; {
    homepage = "https://help.cloudsmith.io/docs/cli/";
    description = "Cloudsmith Command Line Interface";
    mainProgram = "cloudsmith";
    changelog = "https://github.com/cloudsmith-io/cloudsmith-cli/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
    platforms = with platforms; unix;
  };
}
