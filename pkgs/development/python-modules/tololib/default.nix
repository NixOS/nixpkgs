{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "tololib";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "MatthiasLohr";
    repo = "tololib";
    rev = "refs/tags/v${version}";
    hash = "sha256-dfyc96VcauERv2E5I6nOIXAHbmTHiRLqS+0XH0GB5HM=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [ "tololib" ];

  # Network discovery doesn't work in the sandbox for darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Python Library for Controlling TOLO Sauna/Steam Bath Devices";
    homepage = "https://gitlab.com/MatthiasLohr/tololib";
    changelog = "https://gitlab.com/MatthiasLohr/tololib/-/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "tolo-cli";
  };
}
