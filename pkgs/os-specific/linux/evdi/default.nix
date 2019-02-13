{ stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  name = "evdi-${version}";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "v${version}";
    sha256 = "0jy0ia5fsx54d2wv4d2jqnc8rc5x16781a3bcb857apc47zr387h";
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
    broken = versionOlder kernel.version "4.9" || versionAtLeast kernel.version "4.18" || stdenv.isAarch64;
  };
}
