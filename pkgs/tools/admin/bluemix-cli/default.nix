{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bluemix-cli-${version}";
  version = "0.6.6";

  src = fetchurl {
    name = "linux64.tar.gz";
    url = "https://clis.ng.bluemix.net/download/bluemix-cli/${version}/linux64";
    sha256 = "1swjawc4szqrl0wgjcb4na1hbxylaqp2mp53lxsbfbk1db0c3y85";
  };

  installPhase = ''
    install -m755 -D --target $out/bin bin/bluemix bin/bluemix-analytics bin/cfcli/cf
  '';

  meta = with lib; {
    description  = "Administration CLI for IBM BlueMix";
    homepage     = "https://console.bluemix.net/docs/cli/index.html";
    downloadPage = "https://console.bluemix.net/docs/cli/reference/bluemix_cli/download_cli.html#download_install";
    license      = licenses.unfree;
    maintainers  = [ maintainers.tazjin ];
    platforms    = [ "x86_64-linux" ];
  };
}
