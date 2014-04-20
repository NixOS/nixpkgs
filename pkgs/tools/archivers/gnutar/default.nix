{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gnutar-${version}";
  version = "1.27.1";

  src = fetchurl {
    url = "mirror://gnu/tar/tar-${version}.tar.bz2";
    sha256 = "1iip0fk0wqhxb0jcwphz43r4fxkx1y7mznnhmlvr618jhp7b63wv";
  };

  # May have some issues with root compilation because the bootstrap tool
  # cannot be used as a login shell for now.
  FORCE_UNSAFE_CONFIGURE = stdenv.lib.optionalString (stdenv.system == "armv7l-linux" || stdenv.isSunOS) "1";

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

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
