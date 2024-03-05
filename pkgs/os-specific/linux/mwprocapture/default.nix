{ lib, stdenv, fetchurl, kernel, alsa-lib }:

with lib;

let
  bits =
    if stdenv.is64bit then "64"
    else "32";

  libpath = makeLibraryPath [ stdenv.cc.cc stdenv.cc.libc alsa-lib ];

in
stdenv.mkDerivation rec {
  pname = "mwprocapture";
  subVersion = "4373";
  version = "1.3.0.${subVersion}-${kernel.version}";

  src = fetchurl {
    url = "https://www.magewell.com/files/drivers/ProCaptureForLinux_${subVersion}.tar.gz";
    sha256 = "sha256-/6q+6CTlgkHOgq1PF8dSPfl/xm/UFczr/AGkac2mXZ8=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    cd ./src
    export INSTALL_MOD_PATH="$out"
  '';

  hardeningDisable = [ "pic" "format" ];

  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-fallthrough";

  postInstall = ''
    cd ../
    mkdir -p $out/bin
    cp bin/mwcap-control_${bits} $out/bin/mwcap-control
    cp bin/mwcap-info_${bits} $out/bin/mwcap-info
    mkdir -p $out/lib/udev/rules.d
    # source has a filename typo
    cp scripts/10-procatpure-event-dev.rules $out/lib/udev/rules.d/10-procapture-event-dev.rules
    cp -r src/res $out

    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath "${libpath}" \
      "$out"/bin/mwcap-control

    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath "${libpath}" \
      "$out"/bin/mwcap-info
  '';

  meta = {
    homepage = "https://www.magewell.com/";
    description = "Linux driver for the Magewell Pro Capture family";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ flexiondotorg MP2E ];
    platforms = platforms.linux;
  };
}
