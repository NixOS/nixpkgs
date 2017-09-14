{ stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  name = "evdi-${version}";
  version = "1.4.1+git2017-06-12";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "ee1c578774e62fe4b08d92750620ed3094642160";
    sha256 = "1m3wkmw4hjpjax7rvhmpicz09d7vxcxklq797ddjg6ljvf12671b";
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
    broken = versionOlder kernel.version "4.9";
  };
}
