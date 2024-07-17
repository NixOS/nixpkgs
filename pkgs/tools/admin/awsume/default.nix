{
  lib,
  python3,
  installShellFiles,
  buildPythonApplication,
  fetchFromGitHub,
  boto3,
  colorama,
  psutil,
  pluggy,
  pyyaml,
}:

buildPythonApplication rec {
  pname = "awsume";
  version = "4.5.3";

  src = fetchFromGitHub {
    owner = "trek10inc";
    repo = "awsume";
    rev = version;
    sha256 = "sha256-An7omHk2Yxjc6db6Y8QSrtgUvSF5rlVhgxMTpNOePHo=";
  };

  AWSUME_SKIP_ALIAS_SETUP = 1;

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    colorama
    boto3
    psutil
    pluggy
    pyyaml
  ];

  postPatch = ''
    patchShebangs shell_scripts
    substituteInPlace shell_scripts/{awsume,awsume.fish} --replace "awsumepy" "$out/bin/awsumepy"
  '';

  postInstall = ''
    installShellCompletion --cmd awsume \
      --bash <(PYTHONPATH=./awsume/configure ${python3}/bin/python3 -c"import autocomplete; print(autocomplete.SCRIPTS['bash'])") \
      --zsh <(PYTHONPATH=./awsume/configure ${python3}/bin/python3 -c"import autocomplete; print(autocomplete.SCRIPTS['zsh'])") \
      --fish <(PYTHONPATH=./awsume/configure ${python3}/bin/python3 -c"import autocomplete; print(autocomplete.SCRIPTS['fish'])") \

    rm -f $out/bin/awsume.bat
  '';

  doCheck = false;

  meta = with lib; {
    description = "A utility for easily assuming AWS IAM roles from the command line";
    homepage = "https://github.com/trek10inc/awsume";
    license = [ licenses.mit ];
    maintainers = [ maintainers.nilp0inter ];
  };
}
