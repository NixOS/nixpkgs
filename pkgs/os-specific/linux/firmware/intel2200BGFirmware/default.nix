{ stdenv, fetchurl }:

let version = "3.1"; in

stdenv.mkDerivation {
  name = "intel2200BGFirmware-${version}";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/ipw2200-firmware/ipw2200-fw-${version}.tgz/eaba788643c7cc7483dd67ace70f6e99/ipw2200-fw-${version}.tgz";
    sha256 = "c6818c11c18cc030d55ff83f64b2bad8feef485e7742f84f94a61d811a6258bd";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware
    for fw in \
      ipw2200-bss.fw \
      ipw2200-ibss.fw \
      ipw2200-sniffer.fw
    do
      cp -f $fw $out/lib/firmware/$fw
    done
    mkdir -p $out/share/doc/intel2200BGFirmware
    cp -f LICENSE.ipw2200-fw $out/share/doc/intel2200BGFirmware/LICENSE
  '';

  meta = with stdenv.lib; {
    description = "Firmware for Intel 2200BG cards";
    homepage = http://ipw2200.sourceforge.net/firmware.php;
    license = stdenv.lib.licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ lukasepple ];
    platforms = with platforms; linux;
  };
}
