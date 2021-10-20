{ lib
, fetchFromGitHub
, singularity
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "udocker";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "indigo-dc";
    repo = "udocker";
    rev = "v${version}";
    sha256 = "0dfsjgidsnah8nrclrq10yz3ja859123z81kq4zdifbrhnrn5a2x";
  };

  # crun patchelf proot runc fakechroot
  # are download statistically linked during runtime
  buildInputs = [
    singularity
  ] ++ (with python3Packages; [
    pytest-runner
    pycurl
  ]);

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_05__get_volume_bindings"
  ];

  disabledTestPaths = [
    # Network
    "tests/unit/test_curl.py"
    "tests/unit/test_dockerioapi.py"
  ];

  meta = with lib; {
    description = "basic user tool to execute simple docker containers in user space without root privileges";
    homepage = "https://indigo-dc.gitbooks.io/udocker";
    license = licenses.asl20;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };

}
