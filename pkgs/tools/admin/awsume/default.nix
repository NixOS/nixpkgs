{
  lib,
  python,
  installShellFiles,
  buildPythonApplication,
  fetchFromGitHub,
  bash,
  boto3,
  colorama,
  psutil,
  pluggy,
  pytestCheckHook,
  levenshtein,
  pyyaml,
  setuptools,
  writableTmpDirAsHomeHook,
  xmltodict,
}:

buildPythonApplication rec {
  pname = "awsume";
  version = "4.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trek10inc";
    repo = "awsume";
    tag = version;
    hash = "sha256-lm9YANYckyHDoNbB1wytBm55iyBmUuxFPmZupfpReqc=";
  };

  env.AWSUME_SKIP_ALIAS_SETUP = 1;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    bash
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    colorama
    boto3
    psutil
    pluggy
    levenshtein
    pyyaml
    xmltodict
  ];

  postPatch = ''
    patchShebangs shell_scripts
    substituteInPlace shell_scripts/{awsume,awsume.fish} --replace-fail "awsumepy" "$out/bin/awsumepy"
    substituteInPlace awsume/configure/autocomplete.py --replace-fail "awsume-autocomplete" "$out/bin/awsume-autocomplete"
  '';

  postInstall = ''
    patchShebangs --update --host $out/bin/awsume
    installShellCompletion --cmd awsume \
      --bash <(PYTHONPATH=./awsume/configure ${python.pythonOnBuildForHost.interpreter} -c"import autocomplete; print(autocomplete.SCRIPTS['bash'])") \
      --zsh <(PYTHONPATH=./awsume/configure ${python.pythonOnBuildForHost.interpreter} -c"import autocomplete; print(autocomplete.ZSH_AUTOCOMPLETE_FUNCTION)") \
      --fish <(PYTHONPATH=./awsume/configure ${python.pythonOnBuildForHost.interpreter} -c"import autocomplete; print(autocomplete.SCRIPTS['fish'])") \

    rm -f $out/bin/awsume.bat
  '';

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # rely on configuration setup in $HOME
    "test_safe_print"
    "test_safe_print_color"
    "test_safe_print_end"
    "test_safe_print_ignore_color_on_windows"
  ];

  meta = {
    description = "Utility for easily assuming AWS IAM roles from the command line";
    homepage = "https://awsu.me/";
    license = [ lib.licenses.mit ];
    mainProgram = "awsume";
    maintainers = [ lib.maintainers.nilp0inter ];
  };
}
