{ lib, python3, fetchFromGitHub }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "uefi-firmware-parser";
  version = "1.8";

  # Version 1.8 is not published on pypi
  src = fetchFromGitHub {
    owner = "theopolis";
    repo = "uefi-firmware-parser";
    rev = "v${version}";
    sha256 = "1yn9vi91j1yxkn0icdnjhgl0qrqqkzyhccj39af4f19q1gdw995l";
  };

  meta = with lib; {
    homepage = "https://github.com/theopolis/uefi-firmware-parser/";
    description = "Parse BIOS/Intel ME/UEFI firmware related structures: Volumes, FileSystems, Files, etc";
    mainProgram = "uefi-firmware-parser";
    # MIT + license headers in some files
    license = with licenses; [
      mit
      zlib         # uefi_firmware/me.py
      bsd2         # uefi_firmware/compression/Tiano/**/*
      publicDomain # uefi_firmware/compression/LZMA/SDK/C/*
    ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = [ maintainers.samueldr ];
  };
}
