{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "patchutils-0.3.4";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/patchutils/stable/${name}.tar.xz";
    sha256 = "0xp8mcfyi5nmb5a2zi5ibmyshxkb1zv1dgmnyn413m7ahgdx8mfg";
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
