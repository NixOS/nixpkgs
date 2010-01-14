{ stdenv, fetchurl, devicemapper, libuuid, gettext, readline, utillinuxng }:

stdenv.mkDerivation rec {
  name = "parted-2.1";

  src = fetchurl {
    url = "mirror://gnu/parted/${name}.tar.gz";
    sha256 = "1jc49lv0mglqdvrrh06vfqqmpa0cxczzmd2by6mlpxpblpgrb22a";
  };

  buildInputs = [ libuuid gettext readline libuuid devicemapper ];

  # XXX: For some reason our libreadline.so doesn't have libncurses as
  # NEEDED and `configure' links with `-Wl,--as-needed' so when
  # `AC_CHECK_LIB' tries to link with `-lreadline -lncurses' the latter is
  # removed, leaving `libreadline' with unresolved references.
  #
  # Remove the `preConfigure' hack below when Readline is fixed.
  preConfigure = ''export gl_cv_ignore_unused_libraries=""'';
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

    # GNU Parted requires libuuid, which is part of e2fsprogs.
    platforms = stdenv.lib.platforms.linux;
  };
}
