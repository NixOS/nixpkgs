{ stdenv, fetchFromGitHub, fetchpatch, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "unstable-20210401";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "b0b3d131b26df62664ca33775679eea7b70c47b1";
    sha256 = "09apbvdc78bbqzja9z3b1wrwmqkv3k7cn3lll5gsskxjnqbhxk9y";
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
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
  '';

  meta = with stdenv.lib; {
    description = "Extensible Virtual Display Interface";
    maintainers = with maintainers; [ eyjhb ];
    platforms = platforms.linux;
    license = with licenses; [ lgpl21 gpl2 ];
    homepage = "https://www.displaylink.com/";
    broken = versionOlder kernel.version "4.19" || stdenv.isAarch64;
  };
}
