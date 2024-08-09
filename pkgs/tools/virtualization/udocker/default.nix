{ lib
, fetchFromGitHub
, singularity
, python3Packages
, fetchpatch
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  # crun patchelf proot runc fakechroot
  # are download statistically linked during runtime
  buildInputs = [
    singularity
  ] ++ (with python3Packages; [
    pycurl
  ]);

  patches = [
    (fetchpatch {
      url = "https://github.com/indigo-dc/udocker/commit/9f7d6c5f9a3925bf87d000603c5b306d73bb0fa3.patch";
      sha256 = "sha256-fiqvVqfdVIlILbSs6oDWmbWU9piZEI2oiAKUcmecx9Q=";
    })
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_02__load_structure"
    "test_05__get_volume_bindings"
    # AttributeError: 'called_with' is not a valid assertion. Use a spec for the mock if 'called_with' is meant to be an attribute.
    "test_01_init"
    "test_03_setvalue_from_file"
    "test_22__run_banner"
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
    mainProgram = "udocker";
  };

}
