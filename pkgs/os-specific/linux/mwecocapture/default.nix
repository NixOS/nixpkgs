{ lib, stdenv, fetchurl, kernel, alsa-lib }:

with lib;

let
  bits =
    if stdenv.is64bit then "64"
    else "32";

  libpath = makeLibraryPath [ stdenv.cc.cc stdenv.cc.libc alsa-lib ];

in
stdenv.mkDerivation rec {
  pname = "mwecocapture";
  driverVersion = "1.4.227";
  version = "${driverVersion}-${kernel.version}";

  src = fetchurl {
    url = "https://www.magewell.com/files/drivers/EcoCaptureForLinuxX86_${driverVersion}.tar.gz";
    sha256 = "sha256-ANnXCNNvdo0PzzzE9XDZWCqKu5NM5SGSMs5IgXJTkIk=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    cd ./driver
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
    cp bin/mweco-info_${bits} $out/bin/mweco-info
    cp -r res $out

    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath "${libpath}" \
      "$out"/bin/mweco-info
  '';

  meta = {
    homepage = "https://www.magewell.com/";
    description = "Linux driver for the Magewell Eco Capture family";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ hmelder ];
    platforms = platforms.linux;
    mainProgram = "mweco-info";
  };
}
