{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "memtester";
  version = "4.6.0";

  preConfigure = ''
    echo "$CC" > conf-cc
    echo "$CC" > conf-ld
  '';

  src = fetchurl {
    url = "http://pyropus.ca/software/memtester/old-versions/memtester-${version}.tar.gz";
    sha256 = "sha256-yf5Ot+gMjO9SAvkGXEwGgvVhZkfARV6RalcA+Y49uy4=";
  };

  installFlags = [ "INSTALLPATH=$(out)" ];

  meta = with lib; {
    description = "A userspace utility for testing the memory subsystem for faults";
    homepage = "http://pyropus.ca/software/memtester/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
    mainProgram = "memtester";
  };
}
