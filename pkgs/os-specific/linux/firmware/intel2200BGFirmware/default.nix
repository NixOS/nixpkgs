{ lib, fetchzip }:

let version = "3.1"; in

fetchzip {
  name = "intel2200BGFirmware-${version}";
  url = "https://src.fedoraproject.org/repo/pkgs/ipw2200-firmware/ipw2200-fw-${version}.tgz/eaba788643c7cc7483dd67ace70f6e99/ipw2200-fw-${version}.tgz";
  sha256 = "0zjyjndyc401pn5x5lgypxdal21n82ymi3vbb2ja1b89yszj432b";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    install -D -m644 ipw2200-bss.fw     $out/lib/firmware/ipw2200-bss.fw
    install -D -m644 ipw2200-ibss.fw    $out/lib/firmware/ipw2200-ibss.fw
    install -D -m644 ipw2200-sniffer.fw $out/lib/firmware/ipw2200-sniffer.fw
    install -D -m644 LICENSE.ipw2200-fw $out/share/doc/intel2200BGFirmware/LICENSE
  '';

  meta = with lib; {
    description = "Firmware for Intel 2200BG cards";
    homepage = http://ipw2200.sourceforge.net/firmware.php;
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = platforms.linux;
  };
}
