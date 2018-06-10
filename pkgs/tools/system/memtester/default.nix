{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "memtester-${version}";
  version = "4.3.0";

  preConfigure = ''
    echo "$CC" > conf-cc
    echo "$CC" > conf-ld
  '';

  src = fetchurl {
    url = "http://pyropus.ca/software/memtester/old-versions/memtester-${version}.tar.gz";
    sha256 = "127xymmyzb9r6dxqrwd69v7gf8csv8kv7fjvagbglf3wfgyy5pzr";
  };

  installFlags = [ "INSTALLPATH=$(out)" ];

  meta = with stdenv.lib; {
    description = "A userspace utility for testing the memory subsystem for faults";
    homepage = http://pyropus.ca/software/memtester/;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
}
