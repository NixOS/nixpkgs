{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "metabase";
  version = "0.33.2";

  src = fetchurl {
    url = "http://downloads.metabase.com/v${version}/metabase.jar";
    sha256 = "0sbh3xc4scp3qflnd0v7bd224w43rby20nzxb7xn2c80jwninnnl";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/metabase --add-flags "-jar $src"
  '';

  meta = with stdenv.lib; {
    description = "The easy, open source way for everyone in your company to ask questions and learn from data";
    homepage    = "https://metabase.com";
    license     = licenses.agpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ schneefux thoughtpolice mmahut ];
  };
}
