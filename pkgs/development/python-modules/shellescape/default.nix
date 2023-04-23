{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "shellescape";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "chrissimpkins";
    repo = "shellescape";
    rev = "v${version}";
    hash = "sha256-HAe3Qf3lLeVWw/tVkW0J+CfoxSoOnCcWDR2nEWZn7HM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "shellescape" ];

  meta = with lib; {
    description = "Shell escape a string to safely use it as a token in a shell command (backport of Python shlex.quote)";
    homepage = "https://github.com/chrissimpkins/shellescape";
    license = with licenses; [ mit psfl ];
    maintainers = with maintainers; [ veprbl ];
  };
}
