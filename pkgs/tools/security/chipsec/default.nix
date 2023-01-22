{ lib
, stdenv
, fetchFromGitHub
, kernel ? null
, libelf
, nasm
, python3
, withDriver ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chipsec";
  version = "1.8.1";

  disabled = !stdenv.isLinux;

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
    rev = version;
    hash = "sha256-bK8wlwhP0pi8rOs8ysbSZ+0aZOaX4mckfH/p4OLGnes=";
  };

  patches = lib.optionals withDriver [ ./ko-path.diff ./compile-ko.diff ];

  KSRC = lib.optionalString withDriver "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = [
    libelf
    nasm
  ];

  nativeCheckInputs = with python3.pkgs; [
    distro
    pytestCheckHook
  ];

  preBuild = lib.optionalString withDriver ''
    export CHIPSEC_BUILD_LIB=$(mktemp -d)
    mkdir -p $CHIPSEC_BUILD_LIB/chipsec/helper/linux
  '';

  preInstall = lib.optionalString withDriver ''
    mkdir -p $out/${python3.pkgs.python.sitePackages}/drivers/linux
    mv $CHIPSEC_BUILD_LIB/chipsec/helper/linux/chipsec.ko \
      $out/${python3.pkgs.python.sitePackages}/drivers/linux/chipsec.ko
  '';

  setupPyBuildFlags = [
    "--build-lib=$CHIPSEC_BUILD_LIB"
  ] ++ lib.optionals (!withDriver) [
    "--skip-driver"
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
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = [ "x86_64-linux" ] ++ lib.optional (!withDriver) "x86_64-darwin";
  };
}
