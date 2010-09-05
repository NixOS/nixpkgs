{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "sharutils-4.10";

  src = fetchurl {
    url = "mirror://gnu/sharutils/${name}.tar.bz2";
    sha256 = "0q9g8ywsd5vwzzzvrgq3hzfqsdln9rhsqq0dhiwv2sr974c4xz5h";
  };

  # GNU Gettext is needed on non-GNU platforms.
  buildInputs = [ gettext ];

  doCheck = true;

  meta = {
    description = "GNU Sharutils, tools for remote synchronization and `shell archives'";

    longDescription =
      '' GNU shar makes so-called shell archives out of many files, preparing
         them for transmission by electronic mail services.  A shell archive
         is a collection of files that can be unpacked by /bin/sh.  A wide
         range of features provide extensive flexibility in manufacturing
         shars and in specifying shar smartness.  For example, shar may
         compress files, uuencode binary files, split long files and
         construct multi-part mailings, ensure correct unsharing order, and
         provide simplistic checksums.

         GNU unshar scans a set of mail messages looking for the start of
         shell archives.  It will automatically strip off the mail headers
         and other introductory text.  The archive bodies are then unpacked
         by a copy of the shell. unshar may also process files containing
         concatenated shell archives.
      '';

    homepage = http://www.gnu.org/software/sharutils/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
