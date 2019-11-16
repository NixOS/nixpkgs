{ stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gp8xbhd5pmcl95izhpvw9gxfcsbv5f80s6q39l4y3z9j734rb8j";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel libdrm ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
  ];

  hardeningDisable = [ "format" "pic" "fortify" ];

  installPhase = ''
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
  '';

  meta = with stdenv.lib; {
    description = "Extensible Virtual Display Interface";
    homepage = "https://www.displaylink.com/";
    license = with licenses; [ lgpl21 gpl2 ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "4.9" || stdenv.isAarch64;
  };
}
