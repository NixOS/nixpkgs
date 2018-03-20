{ stdenv
, dpkg
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "5.6.36";

  src = fetchurl {
    url = "https://dl.ubnt.com/unifi/${version}/unifi_sysvinit_all.deb";
    sha256 = "075q7vm56fdsjwh72y2cb1pirl2pxdkvqnhvd3bf1c2n64mvp6bi";
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
