{
  lib,
  python,
  installShellFiles,
  buildPythonApplication,
  fetchFromGitHub,
  boto3,
  colorama,
  psutil,
  pluggy,
  pyyaml,
  setuptools,
}:

buildPythonApplication rec {
  pname = "awsume";
  version = "4.5.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "trek10inc";
    repo = "awsume";
    rev = version;
    sha256 = "sha256-lm9YANYckyHDoNbB1wytBm55iyBmUuxFPmZupfpReqc=";
  };

  AWSUME_SKIP_ALIAS_SETUP = 1;

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    colorama
    boto3
    psutil
    pluggy
    pyyaml
    setuptools
  ];

  postPatch = ''
    patchShebangs shell_scripts
    substituteInPlace shell_scripts/{awsume,awsume.fish} --replace-fail "awsumepy" "$out/bin/awsumepy"
    substituteInPlace awsume/configure/autocomplete.py --replace-fail "awsume-autocomplete" "$out/bin/awsume-autocomplete"
  '';

  postInstall = ''
    installShellCompletion --cmd awsume \
      --bash <(PYTHONPATH=./awsume/configure ${python}/bin/python3 -c"import autocomplete; print(autocomplete.SCRIPTS['bash'])") \
      --zsh <(PYTHONPATH=./awsume/configure ${python}/bin/python3 -c"import autocomplete; print(autocomplete.ZSH_AUTOCOMPLETE_FUNCTION)") \
      --fish <(PYTHONPATH=./awsume/configure ${python}/bin/python3 -c"import autocomplete; print(autocomplete.SCRIPTS['fish'])") \

    rm -f $out/bin/awsume.bat
  '';

  doCheck = false;

  meta = with lib; {
    description = "Utility for easily assuming AWS IAM roles from the command line";
    homepage = "https://github.com/trek10inc/awsume";
    license = [ licenses.mit ];
    mainProgram = "awsume";
    maintainers = [ maintainers.nilp0inter ];
  };
}
