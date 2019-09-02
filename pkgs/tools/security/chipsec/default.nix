{ stdenv, lib, fetchFromGitHub, python27Packages, nasm, libelf
, kernel ? null, withDriver ? false }:
python27Packages.buildPythonApplication rec {
  name = "chipsec-${version}";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "chipsec";
    repo = "chipsec";
    rev = version;
    sha256 = "00hwhi5f24y429zazhm77l1pp31q7fmx7ks3sfm6d16v89zbcp9a";
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
