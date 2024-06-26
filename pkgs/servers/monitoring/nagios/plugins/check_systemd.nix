{
  fetchFromGitHub,
  python3Packages,
  lib,
}:

python3Packages.buildPythonApplication rec {
  pname = "check_systemd";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Josef-Friedrich";
    repo = pname;
    rev = "v${version}";
    sha256 = "11sc0gycxzq1vfvin501jnwnky2ky6ns64yjiw8vq9vmkbf8nni6";
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
  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  meta = with lib; {
    description = "Nagios / Icinga monitoring plugin to check systemd for failed units";
    mainProgram = "check_systemd";
    inherit (src.meta) homepage;
    changelog = "https://github.com/Josef-Friedrich/check_systemd/releases";
    maintainers = with maintainers; [ symphorien ];
    license = licenses.lgpl2Only;
    platforms = platforms.linux;
  };
}
