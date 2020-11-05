{ stdenv, fetchFromGitHub, fetchpatch, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "unstable-20200731";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "1e6bf705cb21efb3272cc488d5b7caee69413f28";
    sha256 = "0r902j54pbcl1cb1gbwqrdkr4klgak98rd5nvxx0nrcymy91pn32";
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
