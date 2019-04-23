{ stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  name = "evdi-${version}";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "v${version}";
    sha256 = "1mv2sydynhqxhzyqqma4hjpm8y7pzxpg1gdmwnjq8h2680q70m91";
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
