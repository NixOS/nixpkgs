{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gnutar-1.26";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-1.26.tar.bz2";
    sha256 = "0hbdkzmchq9ycr2x1pxqdcgdbaxksh8c6ac0jf75jajhcks6jlss";
  };

  patches = [ ./gets-undeclared.patch ];

  # May have some issues with root compilation because the bootstrap tool
  # cannot be used as a login shell for now.
  FORCE_UNSAFE_CONFIGURE = stdenv.lib.optionalString (stdenv.system == "armv7l-linux") "1";

  meta = {
    homepage = http://www.gnu.org/software/tar/;
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

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
