{ stdenv, fetchurl, devicemapper, libuuid, gettext, readline
, utillinuxng, xz }:

stdenv.mkDerivation rec {
  name = "parted-2.3";

  src = fetchurl {
    url = "mirror://gnu/parted/${name}.tar.xz";
    sha256 = "0sabj81nawcjm8ww34lxg65ka8crv3w2ab4crh8ypw5agg681836";
  };

  buildInputs = [ xz libuuid gettext readline libuuid devicemapper ];

  configureFlags = "--with-readline";

  doCheck = true;

  # The `t0400-loop-clobber-infloop.sh' test wants `mkswap'.
  preCheck = "export PATH=\"${utillinuxng}/sbin:$PATH\"";

  meta = {
    description = "GNU Parted, a tool to create, destroy, resize, check, and copy partitions";

    longDescription = ''
      GNU Parted is an industrial-strength package for creating, destroying,
      resizing, checking and copying partitions, and the file systems on
      them.  This is useful for creating space for new operating systems,
      reorganising disk usage, copying data on hard disks and disk imaging.

      It contains a library, libparted, and a command-line frontend, parted,
      which also serves as a sample implementation and script backend.
    '';

    homepage = http://www.gnu.org/software/parted/;
    license = "GPLv3+";

    maintainers = [
      # Add your name here!
      stdenv.lib.maintainers.ludo
    ];

    # GNU Parted requires libuuid, which is part of util-linux-ng.
    platforms = stdenv.lib.platforms.linux;
  };
}
