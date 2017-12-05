{ stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  name = "evdi-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "v${version}";
    sha256 = "176cq83qlmhc4c00dwfnqgd021l7s4gyj8604m5zmxbz0r5mnawv";
  };

  buildInputs = [ kernel libdrm ];

  makeFlags = [ "KVER=${kernel.modDirVersion}" "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  hardeningDisable = [ "pic" "format" ];

  installPhase = ''
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
  '';

  meta = with stdenv.lib; {
    description = "Extensible Virtual Display Interface";
    platforms = platforms.linux;
    license = licenses.gpl2;
    homepage = http://www.displaylink.com/;
    broken = !versionAtLeast kernel.version "3.16";
  };
}
