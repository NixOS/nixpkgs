{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "amdgpu-i2c";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "twifty";
    repo = pname;
    rev = "master";
    sha256 = "sha256-GVyrwnwNSBW4OCNDqQMU6e31C4bG14arC0MPkRWfiJQ=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  buildPhase = "make -C ${KDIR} M=/build/source modules";
  installPhase = ''
    make -C ${KDIR} M=/build/source INSTALL_MOD_PATH="$out" modules_install
  '';

  meta = with lib; {
    homepage = "https://github.com/twifty/amd-gpu-i2c";
    downloadPage = "https://github.com/twifty/amd-gpu-i2c";
    description = "Exposes i2c interface to set colors on AMD GPUs";
    broken = lib.versionOlder kernel.version "6.11.0";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thardin ];
  };
}
