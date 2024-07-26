{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
  pname = "hid-tmff2";
  # https://github.com/Kimplul/hid-tmff2/blob/ca168637fbfb085ebc9ade0c47fa0653dac5d25b/dkms/dkms-install.sh#L12
  version = "0.81";

  src = fetchFromGitHub {
    owner = "Kimplul";
    repo = "hid-tmff2";
    rev = "ca168637fbfb085ebc9ade0c47fa0653dac5d25b";
    hash = "sha256-Nm5m5xjwJGy+ia4nTkvPZynIxUj6MVGGbSNmIcIpziM=";
    # For hid-tminit. Source: https://github.com/scarburato/hid-tminit
    fetchSubmodules = true;
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installFlags = [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  postPatch = "sed -i '/depmod -A/d' Makefile";

  meta = with lib; {
    description = "A linux kernel module for Thrustmaster T300RS, T248 and TX(experimental)";
    homepage = "https://github.com/Kimplul/hid-tmff2";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rayslash ];
    platforms = platforms.linux;
  };
}
