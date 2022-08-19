{ lib, stdenv, fetchurl
, pkg-config, python3, sphinx
, zstd
, acl, attr, e2fsprogs, libuuid, lzo, udev, zlib
, runCommand, btrfs-progs
, gitUpdater
, udevSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "btrfs-progs";
  version = "5.18.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    sha256 = "sha256-bpinXM/1LpNU2qGtKExhTEkPhEJzovpSTLrJ64QcclU=";
  };

  nativeBuildInputs = [
    pkg-config
    python3 python3.pkgs.setuptools
    sphinx
  ];

  buildInputs = [ acl attr e2fsprogs libuuid lzo python3 udev zlib zstd ];

  # gcc bug with -O1 on ARM with gcc 4.8
  # This should be fine on all platforms so apply universally
  postPatch = "sed -i s/-O1/-O2/ configure";

  postInstall = ''
    install -v -m 444 -D btrfs-completion $out/share/bash-completion/completions/btrfs
  '';

  configureFlags = lib.optional stdenv.hostPlatform.isMusl "--disable-backtrace"
    ++ lib.optional (!udevSupport) "--disable-libudev";

  makeFlags = [ "udevruledir=$(out)/lib/udev/rules.d" ];

  installFlags = [ "install_python" ];

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
    inherit pname version;
    # No nicer place to find latest release.
    url = "https://github.com/kdave/btrfs-progs.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = "https://btrfs.wiki.kernel.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
