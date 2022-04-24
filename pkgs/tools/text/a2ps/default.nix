{ lib, stdenv, fetchurl, fetchpatch, autoconf, bison, libpaper, gperf, file, perl }:

stdenv.mkDerivation rec {
  pname = "a2ps";
  version = "4.14";

  src = fetchurl {
    url = "mirror://gnu/a2ps/a2ps-${version}.tar.gz";
    sha256 = "195k78m1h03m961qn7jr120z815iyb93gwi159p1p9348lyqvbpk";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/a/a2ps/1:4.14-1.3/debian/patches/09_CVE-2001-1593.diff";
      sha256 = "1hrfmvb21zlklmg2fqikgywhqgc4qnvbhx517w87faafrhzhlnh0";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/a/a2ps/1:4.14-1.3/debian/patches/CVE-2014-0466.diff";
      sha256 = "0grqqsc3m45niac56m19m5gx7gc0m8zvia5iman1l4rlq31shf8s";
    })
    (fetchpatch {
      name = "CVE-2015-8107.patch";
      url = "https://sources.debian.net/data/main/a/a2ps/1:4.14-1.3/debian/patches/fix-format-security.diff";
      sha256 = "0pq7zl41gf2kc6ahwyjnzn93vbxb4jc2c5g8j20isp4vw6dqrnwv";
    })
  ];

  postPatch = ''
    substituteInPlace afm/make_fonts_map.sh --replace "/bin/rm" "rm"
    substituteInPlace tests/defs.in --replace "/bin/rm" "rm"
  '';

  nativeBuildInputs = [ autoconf file bison perl ];
  buildInputs = [ libpaper gperf ];

  meta = with lib; {
    description = "An Anything to PostScript converter and pretty-printer";
    longDescription = ''
      GNU a2ps converts files into PostScript for printing or viewing. It uses a nice default format,
      usually two pages on each physical page, borders surrounding pages, headers with useful information
      (page number, printing date, file name or supplied header), line numbering, symbol substitution as
      well as pretty printing for a wide range of programming languages.
    '';
    homepage = "https://www.gnu.org/software/a2ps/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.linux;

  };
}
