{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "patchutils-0.3.0";

  src = fetchurl {
    url = http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.0.tar.bz2;
    sha256 = "08jzvprhpcgwvx0xlkwc8dbdd9ilvwyr3cwnq96xmbfipch69yi7";
  };

  meta = { 
    description = "Tools to manipulate patch files";
    homepage = http://cyberelk.net/tim/software/patchutils;
    license = "GPLv2";
    executables = [ "combinediff" "dehtmldiff" "editdiff" "espdiff"
      "filterdiff" "fixcvsdiff" "flipdiff" "grepdiff" "interdiff" "lsdiff"
      "recountdiff" "rediff" "splitdiff" "unwrapdiff" ];
  };
}
