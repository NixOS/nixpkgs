{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jetty-9.2.5";

  src = fetchurl {
    url = "http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.2.5.v20141112.tar.gz&r=1";
    name = "jetty-distribution-9.2.5.v20141112.tar.gz";
    sha256 = "1azqhvvqm9il5n07vms5vv27vr3qhmsy44nmqcgsaggq7p37swf1";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out
    mv etc lib modules start.jar $out
  '';

  meta = {
    description = "A Web server and javax.servlet container";

    homepage = http://www.eclipse.org/jetty/;

    maintainers = [ stdenv.lib.maintainers.shlevy ];

    platforms = stdenv.lib.platforms.all;

    license = [ stdenv.lib.licenses.asl20 stdenv.lib.licenses.epl10 ];
  };
}
