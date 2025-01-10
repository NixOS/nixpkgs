{ lib
, fetchFromGitHub
, singularity
, python3Packages
, testers
, udocker
}:

python3Packages.buildPythonApplication rec {
  pname = "udocker";
  version = "1.3.16";

  src = fetchFromGitHub {
    owner = "indigo-dc";
    repo = "udocker";
    rev = "refs/tags/${version}";
    hash = "sha256-PUbNFvKaF41egGMypdkmVFCt1bWmTCWR5iQNOt/L4+Y=";
  };

  # crun patchelf proot runc fakechroot
  # are download statistically linked during runtime
  buildInputs = [
    singularity
  ];

  dependencies = with python3Packages; [
    pycurl
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-runner
    pytestCheckHook
  ];

  disabledTests = [
    "test_02__load_structure"
    "test_05__get_volume_bindings"
  ];

  disabledTestPaths = [
    # Network
    "tests/unit/test_curl.py"
    "tests/unit/test_dockerioapi.py"
  ];

  passthru = {
    tests.version = testers.testVersion { package = udocker; };
  };

  meta = {
    description = "basic user tool to execute simple docker containers in user space without root privileges";
    homepage = "https://indigo-dc.gitbooks.io/udocker";
    changelog = "https://github.com/indigo-dc/udocker/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bzizou ];
    platforms = lib.platforms.linux;
    mainProgram = "udocker";
  };
}
