{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "memtester";
  version = "4.5.0";

  preConfigure = ''
    echo "$CC" > conf-cc
    echo "$CC" > conf-ld
  '';

  src = fetchurl {
    url = "http://pyropus.ca/software/memtester/old-versions/memtester-${version}.tar.gz";
    sha256 = "0dxfwayns3hjjplkxkpkm1409lmjlpi4chcrahcvdbnl0q6jpmcf";
  };

  installFlags = [ "INSTALLPATH=$(out)" ];

  meta = with lib; {
    description = "A userspace utility for testing the memory subsystem for faults";
    homepage = "http://pyropus.ca/software/memtester/";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
}
