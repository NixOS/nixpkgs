{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "metabase-${version}";
  version = "0.28.6";

  src = fetchurl {
    url = "http://downloads.metabase.com/v${version}/metabase.jar";
    sha256 = "1dzs57yyx6k93gvyva9y38xdb4pbvdliad3zzgk3vs74fp1zh2vq";
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
