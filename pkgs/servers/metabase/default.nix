{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "metabase-${version}";
  version = "0.30.4";

  src = fetchurl {
    url = "http://downloads.metabase.com/v${version}/metabase.jar";
    sha256 = "0mvyl5v798qwdydqsjjq94ihfwi62kq4gprxjg3rcckmjdyx2ycs";
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
