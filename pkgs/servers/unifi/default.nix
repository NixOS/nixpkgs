{ stdenv
, dpkg
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "5.5.20";

  src = fetchurl {
    url = "https://www.ubnt.com/downloads/unifi/${version}/unifi_sysvinit_all.deb";
    sha256 = "14v38x46vgwm3wg28lzv4sz6kjgp6r1xkwxnxn6pzq2r7v6xkaz0";
  };

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  doConfigure = false;

  installPhase = ''
    mkdir -p $out
    cd ./usr/lib/unifi
    cp -ar dl lib webapps $out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.ubnt.com/;
    description = "Controller for Ubiquiti UniFi accesspoints";
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
