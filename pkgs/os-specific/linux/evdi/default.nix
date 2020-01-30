{ stdenv, fetchFromGitHub, fetchpatch, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "-unstable-20190116";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "391f1f71e4c86fc18de27947c78e02b5e3e9f128";
    sha256 = "147cwmk57ldchvzr06lila6av7jvcdggs9jgifqscklp9x6dc4ny";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel libdrm ];

  patches = [
    (fetchpatch {
      url    = "https://crazy.dev.frugalware.org/evdi-all-in-one-fixes.patch";
      sha256 = "03hs68v8c2akf8a4rc02m15fzyp14ay70rcx8kwg2y98qkqh7w30";
    })
  ];

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
