{ stdenv, fetchurl, gettext, coreutils }:

stdenv.mkDerivation rec {
  name = "sharutils-4.15.2";

  src = fetchurl {
    url = "mirror://gnu/sharutils/${name}.tar.xz";
    sha256 = "16isapn8f39lnffc3dp4dan05b7x6mnc76v6q5nn8ysxvvvwy19b";
  };

  hardeningDisable = [ "format" ];

  # GNU Gettext is needed on non-GNU platforms.
  buildInputs = [ coreutils gettext ];

  doCheck = true;

  crossAttrs = {
    patches = [ ./sharutils-4.11.1-cross-binary-mode-popen.patch ];
  };

  meta = with stdenv.lib; {
    description = "Tools for remote synchronization and `shell archives'";
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
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.ndowens ];
    platforms = platforms.all;
  };
}
