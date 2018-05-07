{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "bluemix-cli-${version}";
  version = "0.6.6";

  src = fetchzip {
    url    = "https://clis.ng.bluemix.net/download/bluemix-cli/${version}/linux64";
    sha256 = "1h3zh8x9681y2ag1wqp003kxlkf1qjnihh3h98wrbmr7f35rmp1x";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/bluemix $out/bin
    cp bin/bluemix-analytics $out/bin
    cp bin/cfcli/cf $out/bin
    chmod 0755 $out/bin/*
  '';

  meta = with lib; {
    description  = "Administration CLI for IBM BlueMix";
    homepage     = "https://console.bluemix.net/docs/cli/index.html";
    downloadPage = "https://console.bluemix.net/docs/cli/reference/bluemix_cli/download_cli.html#download_install";
    license      = licenses.unfree;
    maintainers  = maintainers.tazjin;
    platforms    = platforms.linux;
  };
}
