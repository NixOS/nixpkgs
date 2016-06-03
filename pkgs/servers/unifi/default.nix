{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "unifi-controller-${version}";
  version = "5.0.6";

  src = fetchurl {
    url = "https://dl.ubnt.com/unifi/${version}/UniFi.unix.zip";
    sha256 = "0splrxgh1ppxnf4nynawbn8mwywqsvaib7m60wgnz4inpxhp3pp8";
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
