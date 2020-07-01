{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "VASSAL-3.2.17";

  src = fetchurl {
    url = "mirror://sourceforge/vassalengine/${name}-linux.tar.bz2";
    sha256 = "0nxskr46janxnb31c03zv61kr46vy98l7cwxha3vll81l4ij1sjb";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/vassal $out/doc

    cp CHANGES LICENSE README $out
    cp -R lib/* $out/share/vassal
    cp -R doc/* $out/doc

    makeWrapper ${jre}/bin/java $out/bin/vassal \
      --add-flags "-Duser.dir=$out -cp $out/share/vassal/Vengine.jar \
      VASSAL.launch.ModuleManager"
  '';

  # Don't move doc to share/, VASSAL expects it to be in the root
  forceShare = [ "man" "info" ];

  meta = with stdenv.lib; {
      description = "A free, open-source boardgame engine";
      homepage = "http://www.vassalengine.org/";
      license = licenses.lgpl21;
      maintainers = with maintainers; [ tvestelind ];
      platforms = platforms.linux;
  };
}
