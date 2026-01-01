{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "shellescape";
  version = "3.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "chrissimpkins";
    repo = "shellescape";
    rev = "v${version}";
    hash = "sha256-HAe3Qf3lLeVWw/tVkW0J+CfoxSoOnCcWDR2nEWZn7HM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "shellescape" ];

<<<<<<< HEAD
  meta = {
    description = "Shell escape a string to safely use it as a token in a shell command (backport of Python shlex.quote)";
    homepage = "https://github.com/chrissimpkins/shellescape";
    license = with lib.licenses; [
      mit
      psfl
    ];
    maintainers = with lib.maintainers; [ veprbl ];
=======
  meta = with lib; {
    description = "Shell escape a string to safely use it as a token in a shell command (backport of Python shlex.quote)";
    homepage = "https://github.com/chrissimpkins/shellescape";
    license = with licenses; [
      mit
      psfl
    ];
    maintainers = with maintainers; [ veprbl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
