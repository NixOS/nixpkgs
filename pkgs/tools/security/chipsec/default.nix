{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel ? null,
  elfutils,
  nasm,
  python3,
  withDriver ? false,
  # If this is disabled, you need to manually provide logs output with `-l`,
  # else if it's enabled, they will be automatically created in `/tmp/chipsec`.
  withAutoLogs ? false,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chipsec";
  version = "1.13.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
    tag = version;
    hash = "sha256-8QiFIk9bq/yX26jw9aOd6wtt+WDUwfLBUVD5hL30RKE=";
  };

  patches = lib.optionals withAutoLogs [
    ./log-path.diff
  ];

  KSRC = lib.optionalString withDriver "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = [
    nasm
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.buildPlatform elfutils) [
    elfutils
  ]
  ++ lib.optionals withDriver kernel.moduleBuildDependencies;

  build-system = [ python3.pkgs.setuptools ];
  dependencies = with python3.pkgs; [
    brotli
  ];

  # Marker file preventing driver from being built
  preBuild = lib.optionals (!withDriver) ''
    touch README.NO_KERNEL_DRIVER
  '';

  nativeCheckInputs = with python3.pkgs; [
    distro
    pytestCheckHook
  ];

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

  makeWrapperArgs = lib.optionalString (!withAutoLogs) [
    "--add-flags -nl" # don't save logs automatically
  ];

  pythonImportsCheck = [
    "chipsec"
  ];

  meta = with lib; {
    description = "Platform Security Assessment Framework";
    longDescription = ''
      CHIPSEC is a framework for analyzing the security of PC platforms
      including hardware, system firmware (BIOS/UEFI), and platform components.
      It includes a security test suite, tools for accessing various low level
      interfaces, and forensic capabilities. It can be run on Windows, Linux,
      Mac OS X and UEFI shell.
    '';
    license = licenses.gpl2Only;
    homepage = "https://github.com/chipsec/chipsec";
    maintainers = with maintainers; [
      johnazoidberg
      erdnaxe
    ];
    platforms = if withDriver then [ "x86_64-linux" ] else with lib.platforms; linux ++ darwin;
    # https://github.com/chipsec/chipsec/issues/1793
    broken = withDriver && kernel.kernelOlder "5.4" && kernel.isHardened;
    mainProgram = "chipsec_main";
  };
}
