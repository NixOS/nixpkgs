{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "memtester";
  version = "4.5.1";

  preConfigure = ''
    echo "$CC" > conf-cc
    echo "$CC" > conf-ld
  '';

  src = fetchurl {
    url = "http://pyropus.ca/software/memtester/old-versions/memtester-${version}.tar.gz";
    sha256 = "sha256-HF/COCV2wISzFM/TNNEnpmwgvWOJLKyfRFvB2LTKWkc=";
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
