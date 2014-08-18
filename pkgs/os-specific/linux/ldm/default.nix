{ stdenv, fetchgit, udev, utillinux, mountPath ? "/media/" }:

assert mountPath != "";

let
  version = "v0.4.2";
  git = https://github.com/LemonBoy/ldm.git;
in
stdenv.mkDerivation rec {
  name = "ldm-${version}";

  # There is a stable release, but we'll use the lvm branch, which
  # contains important fixes for LVM setups.
  src = fetchgit {
    url = meta.repositories.git;
    rev = "refs/tags/${version}";
    sha256 = "1fdm3l00csjyvz40py6wlsh8s441rbp4az3sc2i14ag7srh2yim8";
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
    repositories.git = git;
  };
}
