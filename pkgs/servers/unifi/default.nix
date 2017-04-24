{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "5.4.14";

  src = fetchurl {
    url = "https://dl.ubnt.com/unifi/${version}/UniFi.unix.zip";
    sha256 = "16scryd8g0dsswawwadxxqsirir6mn0jaawv3qcszqj52vlz878w";
  };

  buildInputs = [ unzip ];

  doConfigure = false;

  buildPhase = ''
    rm -rf bin conf readme.txt
  '';

  installPhase = ''
    mkdir -p $out
    cp -ar * $out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.ubnt.com/;
    description = "Controller for Ubiquiti UniFi accesspoints";
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
