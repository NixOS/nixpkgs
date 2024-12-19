{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools-scm,
  click,
  help2man,
  markdown-it-py,
  shtab,
  tomli,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "setuptools-generate";
  version = "0.0.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "setuptools-generate";
    rev = "refs/tags/${version}";
    hash = "sha256-xDjxkWy/n0jStI9eLcM6WduyU9vGjtBOmJ86dpXjceQ=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    click
    help2man
    markdown-it-py
    shtab
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "setuptools_generate" ];

  meta = with lib; {
    description = "Generate shell completions and man page when building a python package";
    homepage = "https://github.com/Freed-Wu/setuptools-generate";
    changelog = "https://github.com/Freed-Wu/setuptools-generate/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ natsukium ];
  };
}
