{ fetchFromGitHub, python3Packages, lib }:

python3Packages.buildPythonApplication rec {
  pname = "check_systemd";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Josef-Friedrich";
    repo = pname;
    rev = "v${version}";
    sha256 = "04r14dhqzrdndn235dvr6afy4s4g4asynsgvj99cmyq55nah4asn";
  };

  propagatedBuildInputs = with python3Packages; [ nagiosplugin ];

  postInstall = ''
    # check_systemd is only a broken stub calling check_systemd.py
    mv $out/bin/check_systemd{.py,}
  '';

  # the test scripts run ./check_systemd.py and check_systemd. Patch to
  # the installed, patchShebanged executable in $out/bin
  preCheck = ''
    find test -name "*.py" -execdir sed -i "s@./check_systemd.py@$out/bin/check_systemd@" '{}' ";"
    export PATH=$PATH:$out/bin
  '';
  checkInputs = [ python3Packages.pytestCheckHook ];

  meta = with lib; {
    description = "Nagios / Icinga monitoring plugin to check systemd for failed units";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ symphorien ];
    license = licenses.lgpl2Only;
    platforms = platforms.linux;
  };
}
