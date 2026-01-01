{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel ? null,
  elfutils,
  nasm,
  python3,
  withDriver ? false,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chipsec";
<<<<<<< HEAD
  version = "1.13.17";
  pyproject = true;
=======
  version = "1.10.6";
  format = "setuptools";

  disabled = !stdenv.hostPlatform.isLinux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-8QiFIk9bq/yX26jw9aOd6wtt+WDUwfLBUVD5hL30RKE=";
  };

  patches = [
    ./log-path.diff
  ];

=======
    rev = version;
    hash = "sha256-+pbFG1SmSO/cnt1e+kel7ereC0I1OCJKKsS0KaJDWdc=";
  };

  patches = lib.optionals withDriver [
    ./ko-path.diff
    ./compile-ko.diff
  ];

  postPatch = ''
    substituteInPlace tests/software/util.py \
      --replace-fail "assertRegexpMatches" "assertRegex"
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  KSRC = lib.optionalString withDriver "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = [
    nasm
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.buildPlatform elfutils) [
    elfutils
  ]
  ++ lib.optionals withDriver kernel.moduleBuildDependencies;

<<<<<<< HEAD
  build-system = [ python3.pkgs.setuptools ];
  dependencies = with python3.pkgs; [
    brotli
  ];

  # Marker file preventing driver from being built
  preBuild = lib.optionals (!withDriver) ''
    touch README.NO_KERNEL_DRIVER
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = with python3.pkgs; [
    distro
    pytestCheckHook
  ];

<<<<<<< HEAD
  # Otherwise chipsec tries and fails import "tpm_cmd"
  postInstall = ''
    cp -R chipsec/library/tpm $out/${python3.pkgs.python.sitePackages}/chipsec/library/tpm
  ''
  # Allow the kernel module to be loaded manually
  + lib.optionalString withDriver ''
    pushd $out/${python3.pkgs.python.sitePackages}/chipsec/helper/linux/
      xz -k chipsec.ko
      install -Dm444 chipsec.ko.xz $out/lib/modules/${kernel.modDirVersion}/chipsec.ko.xz
      rm chipsec.ko.xz
    popd
  '';

=======
  preBuild = lib.optionalString withDriver ''
    export CHIPSEC_BUILD_LIB=$(mktemp -d)
    mkdir -p $CHIPSEC_BUILD_LIB/chipsec/helper/linux
    appendToVar setupPyBuildFlags "--build-lib=$CHIPSEC_BUILD_LIB"
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=dangling-pointer"
  ];

  preInstall = lib.optionalString withDriver ''
    mkdir -p $out/${python3.pkgs.python.sitePackages}/drivers/linux
    mv $CHIPSEC_BUILD_LIB/chipsec/helper/linux/chipsec.ko \
      $out/${python3.pkgs.python.sitePackages}/drivers/linux/chipsec.ko
  '';

  setupPyBuildFlags = lib.optionals (!withDriver) [
    "--skip-driver"
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [
    "chipsec"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Platform Security Assessment Framework";
    longDescription = ''
      CHIPSEC is a framework for analyzing the security of PC platforms
      including hardware, system firmware (BIOS/UEFI), and platform components.
      It includes a security test suite, tools for accessing various low level
      interfaces, and forensic capabilities. It can be run on Windows, Linux,
      Mac OS X and UEFI shell.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/chipsec/chipsec";
    maintainers = with lib.maintainers; [
      johnazoidberg
      erdnaxe
    ];
    platforms = if withDriver then [ "x86_64-linux" ] else with lib.platforms; linux ++ darwin;
    # https://github.com/chipsec/chipsec/issues/1793
    broken = withDriver && kernel.kernelOlder "5.4" && kernel.isHardened;
    mainProgram = "chipsec_main";
=======
    license = licenses.gpl2Only;
    homepage = "https://github.com/chipsec/chipsec";
    maintainers = with maintainers; [
      johnazoidberg
      erdnaxe
    ];
    platforms = [ "x86_64-linux" ] ++ lib.optional (!withDriver) "x86_64-darwin";
    # https://github.com/chipsec/chipsec/issues/1793
    broken = withDriver && kernel.kernelOlder "5.4" && kernel.isHardened;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
