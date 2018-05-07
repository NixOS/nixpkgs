{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "metabase-${version}";
  version = "0.29.0";

  src = fetchurl {
    url = "http://downloads.metabase.com/v${version}/metabase.jar";
    sha256 = "1dfq06cm8k36pkqpng4cd8ax8cdxbcssww4vapq2w9ccflpnlam2";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/metabase --add-flags "-jar $src"
  '';

  meta = with stdenv.lib; {
    description = "The easy, open source way for everyone in your company to ask questions and learn from data.";
    homepage    = https://metabase.com;
    license     = licenses.agpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ schneefux thoughtpolice ];
  };
}
