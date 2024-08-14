{ lib
, stdenv
, fetchFromGitHub
, kernel ? null
, elfutils
, nasm
, python3
, withDriver ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chipsec";
  version = "1.13.4";

  disabled = !stdenv.isLinux;

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
    rev = version;
    hash = "sha256-MIfWdnVP1p4MrsTXa5phVLYr7fPltaZxspr3mCn1WZQ=";
  };

  patches = lib.optionals withDriver [ ./ko-path.diff ./compile-ko.diff ./fix-setup-copytree.diff ];

  KSRC = lib.optionalString withDriver "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = [
    nasm
  ] ++ lib.optionals (lib.meta.availableOn stdenv.buildPlatform elfutils) [
    elfutils
  ] ++ lib.optionals withDriver kernel.moduleBuildDependencies;

  nativeCheckInputs = with python3.pkgs; [
    distro
    unittestCheckHook
  ];

  preBuild = lib.optionalString withDriver ''
    export CHIPSEC_BUILD_LIB=$(mktemp -d)
    mkdir -p $CHIPSEC_BUILD_LIB/chipsec/helper/linux
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

  postInstall = ''
    mv $out/${python3.pkgs.python.sitePackages}/chipsec/library/module_ids.json $out/${python3.pkgs.python.sitePackages}/chipsec/library/module_ids_default.json
    ln -s /var/lib/chipsec/module_ids.json $out/${python3.pkgs.python.sitePackages}/chipsec/library/module_ids.json
  '';

  createModuleIdsFile =
    let
      module_ids = "/var/lib/chipsec/module_ids.json";
      module_ids_default = "${placeholder "out"}/${python3.pkgs.python.sitePackages}/chipsec/library/module_ids_default.json";
    in
    ''
    if [ ! -e ${module_ids} ]; then
    mkdir -p $(dirname ${module_ids})
    cp ${module_ids_default} ${module_ids}
    fi
    '';

  makeWrapperArgs = [
    ''--run '${createModuleIdsFile}' ''
  ];

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
    maintainers = with maintainers; [ johnazoidberg erdnaxe ];
    platforms = [ "x86_64-linux" ] ++ lib.optional (!withDriver) "x86_64-darwin";
    # https://github.com/chipsec/chipsec/issues/1793
    broken = withDriver && kernel.kernelOlder "5.4" && kernel.isHardened;
  };
}
