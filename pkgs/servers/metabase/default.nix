{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "metabase-${version}";
  version = "0.30.3";

  src = fetchurl {
    url = "http://downloads.metabase.com/v${version}/metabase.jar";
    sha256 = "1w8886xkg88r8dla4l9kpxw2rwwjx23y1dk5rgfgh1vcw8da8cn4";
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
