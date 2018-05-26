{ stdenv, fetchurl, kernel, alsaLib }:

with stdenv.lib;

# The Magewell Pro Capture drivers are not supported for kernels older than 3.2
assert versionAtLeast kernel.version "3.2.0";

let
  bits =
  if stdenv.is64bit then "64"
  else "32";

  libpath = makeLibraryPath [ stdenv.cc.cc stdenv.glibc alsaLib ];

in
stdenv.mkDerivation rec {
  name = "mwprocapture-1.2.${version}-${kernel.version}";
  version = "3773";

  src = fetchurl {
    url = "http://www.magewell.com/files/drivers/ProCaptureForLinux_${version}.tar.gz";
    sha256 = "1ri7c4l4xgkhpz0f15jra1p7mpzi8ir6lpwjm7q7hc9m4cvxcs1g";
  };

  nativeBuildInputs = [ kernel.moduleBuildDependencies ];

  patches = [ ./linux_4_14_fix.patch ];

  preConfigure =
  ''
    cd ./src
    export INSTALL_MOD_PATH="$out"
  '';

  hardeningDisable = [ "pic" "format" ];

  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

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
    homepage = http://www.magewell.com/;
    description = "Linux driver for the Magewell Pro Capture family";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.linux;
  };
}
