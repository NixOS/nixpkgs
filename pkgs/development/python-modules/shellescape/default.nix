{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "shellescape";
  version = "3.8.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chrissimpkins";
    repo = "shellescape";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HAe3Qf3lLeVWw/tVkW0J+CfoxSoOnCcWDR2nEWZn7HM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "shellescape" ];

  meta = {
    description = "Shell escape a string to safely use it as a token in a shell command (backport of Python shlex.quote)";
    homepage = "https://github.com/chrissimpkins/shellescape";
    license = with lib.licenses; [
      mit
      psfl
    ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
