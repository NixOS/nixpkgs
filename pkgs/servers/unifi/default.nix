{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "4.8.14";

  src = fetchurl {
    url = "https://www.ubnt.com/downloads/unifi/${version}/UniFi.unix.zip";
    sha256 = "04gvvz9vyi4aw97hh8fp8mp19mpx3axy9rb2x8vfck4w76cdi614";
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
