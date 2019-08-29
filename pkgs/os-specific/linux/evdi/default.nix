{ stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ajjsh1fw7w0k28r6qq7kh3qcr87gzzjp8s890algbglynlafzfw";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel libdrm ];

  makeFlags = [ "KVER=${kernel.modDirVersion}" "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  hardeningDisable = [ "format" "pic" "fortify" ];

  installPhase = ''
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
  '';

  meta = with stdenv.lib; {
    description = "Extensible Virtual Display Interface";
    platforms = platforms.linux;
    license = with licenses; [ lgpl21 gpl2 ];
    homepage = https://www.displaylink.com/;
    broken = versionOlder kernel.version "4.9" || versionAtLeast kernel.version "5.3" || stdenv.isAarch64;
  };
}
