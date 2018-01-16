{ stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  name = "evdi-${version}";
  version = "unstable-2018-01-12";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "e7a08d08e3876efba8007e91df1b296f2447b8de";
    sha256 = "01z7bx5rgpb5lc4c6dxfiv52ni25564djxmvmgy3d7r1x1mqhxgs";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

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
