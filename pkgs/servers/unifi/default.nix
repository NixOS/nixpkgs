{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "4.7.6";

  src = fetchurl {
    url = "https://www.ubnt.com/downloads/unifi/${version}/UniFi.unix.zip";
    sha256 = "0xinrxcbd5gb2jgcvrx3jcslad0f19qrbjzkiir9zjq59sn68gfn";
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
    maintainers = with maintainers; [ wkennington ];
  };
}
