args:
args.stdenv.mkDerivation {
  name = "patchutils-0.3.0";

  src = args.fetchurl {
    url = http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.0.tar.bz2;
    sha256 = "08jzvprhpcgwvx0xlkwc8dbdd9ilvwyr3cwnq96xmbfipch69yi7";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "collection of programs that operate on patch files, fix"
        + " diffs after manually editing them, create a diff of diffs etc";
      homepage = http://cyberelk.net/tim/software/patchutils;
      license = "GPLv2";
      executables = [ "combinediff" "dehtmldiff" "editdiff" "espdiff"
        "filterdiff" "fixcvsdiff" "flipdiff" "grepdiff" "interdiff" "lsdiff"
        "recountdiff" "rediff" "splitdiff" "unwrapdiff" ];
  };
}
