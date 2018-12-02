{ stdenv, fetchurl, autoreconfHook, acl }:

stdenv.mkDerivation rec {
  name = "gnutar-${version}";
  version = "1.30";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-${version}.tar.xz";
    sha256 = "1lyjyk8z8hdddsxw0ikchrsfg3i0x3fsh7l63a8jgaz1n7dr5gzi";
  };

  # avoid retaining reference to CF during stdenv bootstrap
  configureFlags = stdenv.lib.optionals stdenv.isDarwin [
    "gt_cv_func_CFPreferencesCopyAppValue=no"
    "gt_cv_func_CFLocaleCopyCurrent=no"
  ];

  # gnutar tries to call into gettext between `fork` and `exec`,
  # which is not safe on darwin.
  # see http://article.gmane.org/gmane.os.macosx.fink.devel/21882
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/system.c --replace '_(' 'N_('
  '';

  outputs = [ "out" "info" ];

  buildInputs = [ ]
    ++ stdenv.lib.optional stdenv.isLinux acl
    ++ stdenv.lib.optional stdenv.isDarwin autoreconfHook;

  # May have some issues with root compilation because the bootstrap tool
  # cannot be used as a login shell for now.
  FORCE_UNSAFE_CONFIGURE = stdenv.lib.optionalString (stdenv.hostPlatform.system == "armv7l-linux" || stdenv.isSunOS) "1";

  preConfigure = if stdenv.isCygwin then ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '' else null;

  doCheck = false; # fails
  doInstallCheck = false; # fails

  meta = {
    homepage = https://www.gnu.org/software/tar/;
    description = "GNU implementation of the `tar' archiver";

    longDescription = ''
      The Tar program provides the ability to create tar archives, as
      well as various other kinds of manipulation.  For example, you
      can use Tar on previously created archives to extract files, to
      store additional files, or to update or list files which were
      already stored.

      Initially, tar archives were used to store files conveniently on
      magnetic tape.  The name "Tar" comes from this use; it stands
      for tape archiver.  Despite the utility's name, Tar can direct
      its output to available devices, files, or other programs (using
      pipes), it can even access remote devices or files (as
      archives).
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
