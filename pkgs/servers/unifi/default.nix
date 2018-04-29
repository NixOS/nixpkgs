{ stdenv
, dpkg
, fetchurl
, unzip
, useLTS ? false
}:


let
  versions = {
    stable = {
      version = "5.7.20";
      sha256 = "1ylj4i5mcv6z9n32275ccdf1rqk74zilqsih3r6xzhm30pxrd8dd";
    };
    lts = {
      version = "5.6.36";
      sha256 = "075q7vm56fdsjwh72y2cb1pirl2pxdkvqnhvd3bf1c2n64mvp6bi";
    };
  };
  selectedVersion =
    let attr = if useLTS then "lts" else "stable";
    in versions."${attr}";
in

stdenv.mkDerivation {
  name = "unifi-controller-${selectedVersion.version}";
  src = with selectedVersion; fetchurl {
    url = "https://dl.ubnt.com/unifi/${version}/unifi_sysvinit_all.deb";
    inherit sha256;
  };

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x $src ./
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
