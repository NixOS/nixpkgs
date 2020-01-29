{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.1.0";

  # Python 2 won't have prompt_toolkit 2.x.x
  # See: https://github.com/NixOS/nixpkgs/blob/f49e2ad3657dede09dc998a4a98fd5033fb52243/pkgs/top-level/python-packages.nix#L3408
  disabled = python3Packages.isPy27;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0cqil2cmnbw0jvb14v6kbr7l9yarfgy253cbb8v9znp0l4qfs7ra";
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
    pytest
    mock
  ];

  preCheck = ''
    export XDG_CONFIG_HOME=$TMP
    # add missing file
    echo "litecli is awesome!" > tests/test.txt
  '';

  meta = with lib; {
    description = "Command-line interface for SQLite";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = https://litecli.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
