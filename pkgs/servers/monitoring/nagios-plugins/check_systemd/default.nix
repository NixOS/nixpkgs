{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "check-systemd";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Josef-Friedrich";
    repo = "check_systemd";
    rev = "refs/tags/v${version}";
    hash = "sha256-1e1WtWRTmOxozuOP2ndfsozuiy9LCT/Lsvb+yKH+8eY=";
  };

  postPatch = ''
    substituteInPlace tests/test_argparse.py \
      --replace-fail "./check_systemd.py" "check_systemd"
  '';

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    nagiosplugin
  ];

  # needs to be able to run check_systemd from PATH
  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/Josef-Friedrich/check_systemd/releases";
    description = "Nagios / Icinga monitoring plugin to check systemd for failed units";
    homepage = "https://github.com/Josef-Friedrich/check_systemd";
    license = lib.licenses.lgpl2Only;
    mainProgram = "check_systemd";
    maintainers = with lib.maintainers; [ symphorien ];
    platforms = lib.platforms.linux;
  };
}
