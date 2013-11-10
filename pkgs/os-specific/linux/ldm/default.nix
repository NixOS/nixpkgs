{ stdenv, fetchgit, udev, utillinux, mountPath ? "/media/" }:

assert mountPath != "";

let
  name = "ldm-0.4.2";
in
stdenv.mkDerivation {
  inherit name;

  # There is a stable release, but we'll use the lvm branch, which
  # contains important fixes for LVM setups.
  src = fetchgit {
    url = "https://github.com/LemonBoy/ldm.git";
    rev = "26633ce07b";
    sha256 = "bb733d3b9b3bd5843b9cf1507a04a063c5aa45b398480411709fc727ae10b8b1";
  };

  buildInputs = [ udev utillinux ];

  preBuild = ''
    substituteInPlace ldm.c \
      --replace "/mnt/" "${mountPath}"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v ldm $out/bin
  '';

  meta = {
    description = "A lightweight device mounter, with libudev as only dependency";
    license = "MIT";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
