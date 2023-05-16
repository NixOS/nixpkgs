{ lib, stdenv, fwts, kernel }:

stdenv.mkDerivation rec {
  pname = "fwts-efi-runtime";
  version = "${fwts.version}-${kernel.version}";

  inherit (fwts) src;

<<<<<<< HEAD
  sourceRoot = "${src.name}/efi_runtime";
=======
  sourceRoot = "source/efi_runtime";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    substituteInPlace Makefile --replace \
      '/lib/modules/$(KVER)/build' \
      '${kernel.dev}/lib/modules/${kernel.modDirVersion}/build'
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = kernel.makeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  meta = with lib; {
    inherit (fwts.meta) homepage license;
    description = fwts.meta.description + "(efi-runtime kernel module)";
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
