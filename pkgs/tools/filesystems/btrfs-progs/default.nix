{ lib, stdenv, fetchurl
, pkg-config, sphinx
, zstd
, acl, attr, e2fsprogs, libuuid, lzo, udev, zlib
, runCommand, btrfs-progs
, gitUpdater
, udevSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "btrfs-progs";
  version = "6.2.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "sha256-5IiNuGN9kuZnRIOGmS0IVrlUzyUVuY05tmfaQ8SC1pM=";
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ [
    sphinx
  ];

  buildInputs = [ acl attr e2fsprogs libuuid lzo udev zlib zstd ];

  # gcc bug with -O1 on ARM with gcc 4.8
  # This should be fine on all platforms so apply universally
  postPatch = "sed -i s/-O1/-O2/ configure";

  postInstall = ''
    install -v -m 444 -D btrfs-completion $out/share/bash-completion/completions/btrfs
  '';

  configureFlags = [
    # Built separately, see python3Packages.btrfsutil
    "--disable-python"
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    "--disable-backtrace"
  ] ++ lib.optionals (!udevSupport) [
    "--disable-libudev"
  ];

  makeFlags = [ "udevruledir=$(out)/lib/udev/rules.d" ];

  enableParallelBuilding = true;

  passthru.tests = {
    simple-filesystem = runCommand "btrfs-progs-create-fs" {} ''
      mkdir -p $out
      truncate -s110M $out/disc
      ${btrfs-progs}/bin/mkfs.btrfs $out/disc | tee $out/success
      ${btrfs-progs}/bin/btrfs check $out/disc | tee $out/success
      [ -e $out/success ]
    '';
  };

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://github.com/kdave/btrfs-progs.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = "https://btrfs.readthedocs.io/en/latest/";
    changelog = "https://github.com/kdave/btrfs-progs/raw/v${version}/CHANGES";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
