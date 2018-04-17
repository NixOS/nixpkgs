{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "metabase-${version}";
  version = "0.28.1";

  jar = fetchurl {
    url = "http://downloads.metabase.com/v${version}/metabase.jar";
    sha256 = "1nv3y4pnvzd7lwyj14nmhr3k52qd8hilcjxvd7qr3hb7kzmjvbzk";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/metabase --add-flags "-jar $jar"
  '';

  meta = with stdenv.lib; {
    description = "The easy, open source way for everyone in your company to ask questions and learn from data.";
    homepage = https://metabase.com;
    license = licenses.agpl3;
    maintainers = with maintainers; [ schneefux ];
  };
}
