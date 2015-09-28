{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "4.7.5";

  src = fetchurl {
    url = "http://dl.ubnt.com/unifi/${version}/UniFi.unix.zip";
    sha256 = "1d5jkpwnz4wvcjr5i73m8i5aah6rkxwd0r9239l90v1ja9lkyk7w";
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
