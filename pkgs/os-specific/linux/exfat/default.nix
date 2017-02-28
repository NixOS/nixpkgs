{ stdenv, fetchFromGitHub, kernel }:

# Upstream build for kernel > 4.10 is currently broken
# Reference: https://github.com/dorimanx/exfat-nofuse/issues/103
assert stdenv.lib.versionOlder kernel.version "4.10";

stdenv.mkDerivation rec {
  name = "exfat-nofuse-${version}-${kernel.version}";
  version = "2017-01-03";

  src = fetchFromGitHub {
    owner = "dorimanx";
    repo = "exfat-nofuse";
    rev = "8d291f5";
    sha256 = "0lg1mykglayswli2aliw8chsbr4g629v9chki5975avh43jn47w9";
  };

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -m644 -b -D exfat.ko $out/lib/modules/${kernel.modDirVersion}/kernel/fs/exfat/exfat.ko
  '';

  meta = {
    description = "exfat kernel module";
    homepage = https://github.com/dorimanx/exfat-nofuse;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
