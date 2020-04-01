{ stdenv, fetchFromGitHub, fetchpatch, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "unstable-20200222";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "bb3038c1b10aae99feddc7354c74a5bf22341246";
    sha256 = "058f8gdma6fndg2w512l08mwl79h4hffacx4rnfkjxrb2ard3gd1";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel libdrm ];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  hardeningDisable = [ "format" "pic" "fortify" ];

  installPhase = ''
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so.1.6.4 $out/lib/libevdi.so
  '';

  meta = with stdenv.lib; {
    description = "Extensible Virtual Display Interface";
    platforms = platforms.linux;
    license = with licenses; [ lgpl21 gpl2 ];
    homepage = "https://www.displaylink.com/";
    broken = versionOlder kernel.version "4.9" || stdenv.isAarch64;
  };
}
