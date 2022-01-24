{ lib, git, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "git-aggregator";
  version = "2.1.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-79xNPzYP1j71sU5wZM5e2xTqQExqQEdxXPxbk4T/Scw=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    colorama
    git
    kaptan
    requests
  ];

  checkInputs = [
    git
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
    git config --global user.name John
    git config --global user.email john@localhost
    git config --global init.defaultBranch master
    git config --global pull.rebase false
  '';

  meta = with lib; {
    description = "Manage the aggregation of git branches from different remotes to build a consolidated one";
    homepage = "https://github.com/acsone/git-aggregator";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ lourkeur ];
    mainProgram = "gitaggregate";
  };
}
