{ stdenv, fetchurl, perl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "patchutils";
  version = "0.3.4";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/patchutils/stable/${pname}-${version}.tar.xz";
    sha256 = "0xp8mcfyi5nmb5a2zi5ibmyshxkb1zv1dgmnyn413m7ahgdx8mfg";
  };

  buildInputs = [
    # necessary for ./configure to generate the correct shebangs
    perl
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  # The different tools depend on each other, for example `splitdiff` calls
  # `lsdiff`.
  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH : "$out/bin"
    done
  '';

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
