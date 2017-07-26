{ stdenv
, dpkg
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "5.5.19";

  src = fetchurl {
    url = "https://www.ubnt.com/downloads/unifi/${version}/unifi_sysvinit_all.deb";
    sha256 = "0bsfq48xjp230ir8pm9wpa5p4dh88zfy51lbi2xwpr454371ixcl";
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
