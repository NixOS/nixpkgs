{ git, lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "git-aggregator";
  version = "1.8.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-LLsyhyhPmOOvPzwEEJwkhrDfBMFueA7kuDlnrqwr08k=";
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
    export HOME=`mktemp -d`
    git config --global user.name John
    git config --global user.email john@localhost
  '';

  meta = with lib; {
    description = "Manage the aggregation of git branches from different remotes to build a consolidated one.";
    homepage = "https://github.com/acsone/git-aggregator";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ lourkeur ];
    mainProgram = "gitaggregate";
  };
}
