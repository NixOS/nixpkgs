# This package provides the QHYCCD SDK, which is intended for non-commercial use only.

{ lib
, stdenv
, libusb1
, fxload
, fetchurl
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "qhyccd_sdk";
  version = "23.01.11";
  linux64Sha256 = "3y26mskckf58fnl0l0zbs2v9l3z7kx1xjhxbm61p3qgr3dpzahfw";
  arm64Sha256 = "1qgjmdhqiz9bjf7v58yblcvh8s27w2nzd1z7vynhvrsscg8fv9n6";

  archSuffix = if stdenv.system == "aarch64-linux" then "Arm64" else "linux64";
  strippedVersion = builtins.replaceStrings [ "." "" ] version;

  src = fetchurl {
    url = "https://www.qhyccd.com/file/repository/publish/SDK/${version}/sdk_${archSuffix}_${strippedVersion}.tgz";
    sha256 = if stdenv.system == "aarch64-linux" then arm64Sha256 else linux64Sha256;
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    tar xf ${src}
    cd sdk_${archSuffix}_${version}
    sudo ./distclean.sh
    sudo ./install.sh
  '';

  uninstallPhase = ''
    cd sdk_${archSuffix}_${version}
    sudo ./uninstall.sh
  '';

  shellHook = ''
    echo "Entering QHYCCD SDK shell..."

    installPhase

    # Run the uninstall script when exiting the shell
    trap "sudo ./uninstall.sh" EXIT
  '';

  meta = with lib; {
    homepage = "https://www.qhyccd.com/html/prepub/log_en.html";
    description = "A software development kit for interfacing with QHYCCD astronomy cameras, including libraries and sample code. Non-commercial use only.";
    platforms = platforms.linux;
    license = licenses.unfree;
    requireAllowUnfree = true;
    maintainers = with maintainers; [ realsnick ];
  };
}
