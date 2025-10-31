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
  version = "1.13.17";

  pyproject = true;
  build-system = [ python3.pkgs.setuptools ];

  disabled = !stdenv.hostPlatform.isLinux;

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
    tag = version;
    hash = "sha256-8QiFIk9bq/yX26jw9aOd6wtt+WDUwfLBUVD5hL30RKE=";
  };

  KSRC = lib.optionalString withDriver "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = [
    nasm
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.buildPlatform elfutils) [
    elfutils
  ]
  ++ lib.optionals withDriver kernel.moduleBuildDependencies;

  propagatedBuildInputs = with python3.pkgs; [
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

  pythonImportsCheck = [
    "chipsec"
  ];

  patches = [
    ./log-path.diff
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
    platforms = [ "x86_64-linux" ] ++ lib.optional (!withDriver) "x86_64-darwin";
    # https://github.com/chipsec/chipsec/issues/1793
    broken = withDriver && kernel.kernelOlder "5.4" && kernel.isHardened;
  };
}
