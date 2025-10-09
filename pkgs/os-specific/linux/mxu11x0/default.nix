{
  lib,
  stdenv,
  fetchurl,
  kernel,
}:

let
  srcs = import ./srcs.nix { inherit fetchurl; };
in
stdenv.mkDerivation rec {
  pname = "mxu11x0";

  src = if lib.versionAtLeast kernel.version "5.0" then srcs.mxu11x0_5.src else srcs.mxu11x0_4.src;
  mxu_version =
    if lib.versionAtLeast kernel.version "5.0" then srcs.mxu11x0_5.version else srcs.mxu11x0_4.version;

  version = mxu_version + "-${kernel.version}";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    sed -i -e 's|/lib/modules|${kernel.dev}/lib/modules|' driver/mxconf
    sed -i -e 's|/lib/modules|${kernel.dev}/lib/modules|' driver/Makefile
  '';

  installPhase = ''
    install -v -D -m 644 ./driver/mxu11x0.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/usb/serial/mxu11x0.ko"
    install -v -D -m 644 ./driver/mxu11x0.ko "$out/lib/modules/${kernel.modDirVersion}/misc/mxu11x0.ko"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  hardeningDisable = [ "pic" ];

  meta = with lib; {
    description = "MOXA UPort 11x0 USB to Serial Hub driver";
    homepage = "https://www.moxa.com/en/products/industrial-edge-connectivity/usb-to-serial-converters-usb-hubs/usb-to-serial-converters/uport-1000-series";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ uralbash ];
    platforms = platforms.linux;
    # broken due to API change in write_room() > v5.14-rc1
    # https://github.com/torvalds/linux/commit/94cc7aeaf6c0cff0b8aeb7cb3579cee46b923560
    broken = kernel.kernelAtLeast "5.14";
  };
}
