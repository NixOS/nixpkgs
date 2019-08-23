{ stdenv, fetchurl
, version, sha256, patches ? []
, ...
}:
stdenv.mkDerivation rec {
  pname = "patchutils";
  inherit version patches;

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/patchutils/stable/${pname}-${version}.tar.xz";
    inherit sha256;
  };

  hardeningDisable = [ "format" ];

  doCheck = false; # fails

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
