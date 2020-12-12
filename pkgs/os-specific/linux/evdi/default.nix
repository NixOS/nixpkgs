{ stdenv, fetchFromGitHub, fetchpatch, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "v1.7.2";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = version;
    sha256 = "074j0xh037n8mc4isihfz9lap57wvxaxib32pvy6jhjl3wyik632";
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
    broken = versionOlder kernel.version "4.9" || stdenv.isAarch64;
  };
}
