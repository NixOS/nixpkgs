{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trustymail";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "trustymail";
    rev = "refs/tags/v${version}";
    hash = "sha256-Zkw+NfeVtIArrBxR1qR9bAQe5yd7mAtNiT0x5Mqr3Ic=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      dnspython
      docopt
      publicsuffixlist
      pydns
      pyspf
      requests
    ]
    ++ publicsuffixlist.optional-dependencies.update;

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "trustymail" ];

  meta = with lib; {
    description = "Tool to scan domains and return data based on trustworthy email best practices";
    homepage = "https://github.com/cisagov/trustymail";
    changelog = "https://github.com/cisagov/trustymail/releases/tag/v${version}";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "trustymail";
  };
}
