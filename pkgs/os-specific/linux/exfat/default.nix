{ stdenv, lib, fetchFromGitHub, kernel }:


# Upstream build for kernel 4.1 is broken, 3.12 and below seems to be working
assert lib.versionAtLeast kernel.version  "4.2" || lib.versionOlder kernel.version "4.0";

stdenv.mkDerivation rec {
  name = "exfat-nofuse-${version}-${kernel.version}";
  version = "2017-06-19";

  src = fetchFromGitHub {
    owner = "dorimanx";
    repo = "exfat-nofuse";
    rev = "de4c760bc9a05ead83bc3ec6eec6cf1fb106f523";
    sha256 = "0v979d8sbcb70lakm4jal2ck3gspkdgq9108k127f7ph08vf8djm";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -m644 -b -D exfat.ko $out/lib/modules/${kernel.modDirVersion}/kernel/fs/exfat/exfat.ko
  '';

  meta = {
    description = "exfat kernel module";
    homepage = https://github.com/dorimanx/exfat-nofuse;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ makefu ];
    platforms = lib.platforms.linux;
  };
}
