{ stdenv, fetchurl, devicemapper, libuuid, gettext, readline
, utillinux, check, enableStatic ? false, hurd ? null }:

stdenv.mkDerivation rec {
  name = "parted-3.0";

  src = fetchurl {
    url = "mirror://gnu/parted/${name}.tar.xz";
    sha256 = "054ybvjkj1mbm4mpn1rl12jzhvqg37b0xwwr4ly1zisvzrjhi11a";
  };

  buildInputs = [ libuuid ]
    ++ stdenv.lib.optional (readline != null) readline
    ++ stdenv.lib.optional (gettext != null) gettext
    ++ stdenv.lib.optional (devicemapper != null) devicemapper
    ++ stdenv.lib.optional (hurd != null) hurd
    ++ stdenv.lib.optional doCheck check;

  configureFlags =
       (if (readline != null)
        then [ "--with-readline" ]
        else [ "--without-readline" ])
    ++ stdenv.lib.optional (devicemapper == null) "--disable-device-mapper"
    ++ stdenv.lib.optional enableStatic "--enable-static";

  doCheck = true;

  preCheck =
    stdenv.lib.optionalString doCheck
      # The `t0400-loop-clobber-infloop.sh' test wants `mkswap'.
      "export PATH=\"${utillinux}/sbin:$PATH\"";

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
