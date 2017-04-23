{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchutils-0.3.3";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/patchutils/stable/${name}.tar.xz";
    sha256 = "0g5df00cj4nczrmr4k791l7la0sq2wnf8rn981fsrz1f3d2yix4i";
  };

  patches = [ ./drop-comments.patch ]; # we would get into a cycle when using fetchpatch on this one

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Tools to manipulate patch files";
    homepage = http://cyberelk.net/tim/software/patchutils;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    executables = [ "combinediff" "dehtmldiff" "editdiff" "espdiff"
      "filterdiff" "fixcvsdiff" "flipdiff" "grepdiff" "interdiff" "lsdiff"
      "recountdiff" "rediff" "splitdiff" "unwrapdiff" ];
  };
}
