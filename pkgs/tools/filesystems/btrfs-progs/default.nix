{ lib, stdenv, fetchurl, fetchpatch
, buildPackages
, pkg-config
, zstd
, acl, attr, e2fsprogs, libuuid, lzo, udev, zlib
, runCommand, btrfs-progs
, gitUpdater
, udevSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "btrfs-progs";
  version = "6.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    hash = "sha256-fhSl1ZfzI919G0U+Ok5mGn6fB+oGDvv/T3b/gxWRfeg=";
  };

  patches = [
    # backport fix build with e2fsprogs 1.47.1
    (fetchpatch {
      url = "https://github.com/kdave/btrfs-progs/commit/bcb887a4de2c56426a7a7de8d440b6ad75579f10.patch";
      hash = "sha256-Ir5EiiU0E8GBnGex0Q/WTNexW9XTWFNceiLQvXygIoo=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ] ++ [
    (buildPackages.python3.withPackages (ps: with ps; [
      sphinx
      sphinx-rtd-theme
    ]))
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
