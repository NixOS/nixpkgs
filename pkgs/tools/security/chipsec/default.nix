{ stdenv, lib, fetchFromGitHub, pythonPackages, nasm, libelf
, kernel ? null, withDriver ? false }:
pythonPackages.buildPythonApplication rec {
  name = "chipsec-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
    rev = version;
    sha256 = "043gf21zygvrzvvkwv5xxpcv3ryj5m8klkgyhq0lnh6k594qrg77";
  };

  nativeBuildInputs = [
    nasm libelf
  ];

  setupPyBuildFlags = lib.optional (!withDriver) "--skip-driver";

  checkPhase = "python setup.py build "
             + lib.optionalString (!withDriver) "--skip-driver "
             + "test";

  KERNEL_SRC_DIR = lib.optionalString withDriver "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  meta = with stdenv.lib; {
    description = "Platform Security Assessment Framework";
    longDescription = ''
      CHIPSEC is a framework for analyzing the security of PC platforms
      including hardware, system firmware (BIOS/UEFI), and platform components.
      It includes a security test suite, tools for accessing various low level
      interfaces, and forensic capabilities. It can be run on Windows, Linux,
      Mac OS X and UEFI shell.
    '';
    license = licenses.gpl2;
    homepage = https://github.com/chipsec/chipsec;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = if withDriver then [ "x86_64-linux" ] else platforms.all;
  };
}
