{ stdenv, fetchgit, udev, utillinux, mountPath ? "/media/" }:

assert mountPath != "";

let
  version = "0.5";
  git = https://github.com/LemonBoy/ldm.git;
in
stdenv.mkDerivation rec {
  name = "ldm-${version}";

  # There is a stable release, but we'll use the lvm branch, which
  # contains important fixes for LVM setups.
  src = fetchgit {
    url = meta.repositories.git;
    rev = "refs/tags/v${version}";
    sha256 = "0kkby3a0xgh1lmkbzpsi4am2rqjv3ccgdpic99aw1c76y0ca837y";
  };

  buildInputs = [ udev utillinux ];

  preBuild = ''
    substituteInPlace ldm.c \
      --replace "/mnt/" "${mountPath}"
  '';

  buildPhase = "make ldm";

  installPhase = ''
    mkdir -p $out/bin
    cp -v ldm $out/bin
  '';

  meta = {
    description = "A lightweight device mounter, with libudev as only dependency";
    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
    repositories.git = git;
  };
}
