{ lib, stdenv, fetchurl, fetchpatch, gettext, coreutils, updateAutotoolsGnuConfigScriptsHook }:

stdenv.mkDerivation rec {
  pname = "sharutils";
  version = "4.15.2";

  src = fetchurl {
    url = "mirror://gnu/sharutils/sharutils-${version}.tar.xz";
    sha256 = "16isapn8f39lnffc3dp4dan05b7x6mnc76v6q5nn8ysxvvvwy19b";
  };

  hardeningDisable = [ "format" ];

  # GNU Gettext is needed on non-GNU platforms.
  buildInputs = [ coreutils gettext ];
  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

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
    (fetchurl {
      url = "https://sources.debian.org/data/main/s/sharutils/1:4.15.2-4/debian/patches/02-fix-ftbfs-with-glibc-2.28.patch";
      sha256 = "15kpjqnfs98n6irmkh8pw7masr08xala7gx024agv7zv14722vkc";
    })

    # pending upstream build fix against -fno-common compilers like >=gcc-10
    # Taken from https://lists.gnu.org/archive/html/bug-gnu-utils/2020-01/msg00002.html
    (fetchpatch {
      name = "sharutils-4.15.2-Fix-building-with-GCC-10.patch";
      url = "https://lists.gnu.org/archive/html/bug-gnu-utils/2020-01/txtDL8i6V6mUU.txt";
      sha256 = "0kfch1vm45lg237hr6fdv4b2lh5b1933k0fn8yj91gqm58svskvl";
    })
    (fetchpatch {
      name = "sharutils-4.15.2-Do-not-include-lib-md5.c-into-src-shar.c.patch";
      url = "https://lists.gnu.org/archive/html/bug-gnu-utils/2020-01/txt5Z_KZup0yN.txt";
      sha256 = "0an8vfy3qj6sss9w0i4j8ilf7g5mbc7y13l644jy5bcm9przcjbd";
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

  # Workaround to fix the static build on macOS.
  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  doCheck = true;

  meta = with lib; {
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
    homepage = "https://www.gnu.org/software/sharutils/";
    license = licenses.gpl3Plus;
    maintainers = [];
    platforms = platforms.all;
  };
}
