{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "hid-nintendo";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "nicman23";
    repo = "dkms-hid-nintendo";
    rev = version;
    sha256 = "1c262xarslicn9ildndl66sf97i5pzwzra54zh2rp11j7kkvvbyr";
  };

  prePatch = ''
    cd src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "A Nintendo HID kernel module";
    homepage = "https://github.com/nicman23/dkms-hid-nintendo";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rencire ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "4.14";
  };
}
