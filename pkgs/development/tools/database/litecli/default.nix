{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.5.0";

  # Python 2 won't have prompt_toolkit 2.x.x
  # See: https://github.com/NixOS/nixpkgs/blob/f49e2ad3657dede09dc998a4a98fd5033fb52243/pkgs/top-level/python-packages.nix#L3408
  disabled = python3Packages.isPy27;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "b09f0804d26b018360b240778612390810e8e00ea0f79d5412fd0d4775c0e3cd";
  };

  propagatedBuildInputs = with python3Packages; [
    cli-helpers
    click
    configobj
    prompt_toolkit
    pygments
    sqlparse
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
    mock
  ];

  meta = with lib; {
    description = "Command-line interface for SQLite";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = "https://litecli.com";
    changelog = "https://github.com/dbcli/litecli/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
