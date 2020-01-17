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

  # These tests try to hit /etc/passwd to find out your username if pass in a submitter
  # name on the command line. Since we block access to /etc/passwd on the Darwin sandbox
  # that cause shar to just segfault. It isn't a problem on Linux because their sandbox
  # remaps /etc/passwd to a trivial file, but we can't do that on Darwin so I do this
  # instead. In this case, I pass in the very imaginative "submitter" as the submitter name

  patches = [
    # CVE-2018-1000097
    (fetchurl {
      url = "https://sources.debian.org/data/main/s/sharutils/1:4.15.2-2+deb9u1/debian/patches/01-fix-heap-buffer-overflow-cve-2018-1000097.patch";
      sha256 = "19g0sxc8g79aj5gd5idz5409311253jf2q8wqkasf0handdvsbxx";
    })
  ];

  postPatch = let
      # This evaluates to a string containing:
      #
      #     substituteInPlace tests/shar-2 --replace '${SHAR}' '${SHAR} -s submitter'
      #     substituteInPlace tests/shar-2 --replace '${SHAR}' '${SHAR} -s submitter'
      shar_sub = "\${SHAR}";
    in ''
      substituteInPlace tests/shar-1 --replace '${shar_sub}' '${shar_sub} -s submitter'
      substituteInPlace tests/shar-2 --replace '${shar_sub}' '${shar_sub} -s submitter'

      substituteInPlace intl/Makefile.in --replace "AR = ar" ""
    '';

  doCheck = true;

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
    homepage = https://www.gnu.org/software/sharutils/;
    license = licenses.gpl3Plus;
    maintainers = [];
    platforms = platforms.all;
  };
}
