{ stdenv
, dpkg
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "5.6.22";

  src = fetchurl {
    url = "https://dl.ubnt.com/unifi/${version}/unifi_sysvinit_all.deb";
    sha256 = "1ffphdi4df3jhlcl68amb90f5pj7cwyrql4qwbswynh9d623880l";
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
