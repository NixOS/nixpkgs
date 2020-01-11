{ stdenv, fetchzip, autoreconfHook, libcrafter, libpcap, lua }:

stdenv.mkDerivation rec {
  pname = "tracebox";
  version = "0.2";

  src = fetchzip {
    url = "https://github.com/tracebox/tracebox/archive/v${version}.zip";
    sha256 = "0gxdapm6b5a41gymi1f0nr2kyz70vllnk10085yz3pq527gp9gns";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libcrafter lua ];

  configureFlags = [ "--with-lua=yes" ];

  NIX_LDFLAGS = "${libpcap}/lib/libpcap.so ${libcrafter}/lib/libcrafter.so";

  preAutoreconf = ''
    substituteInPlace Makefile.am --replace "noinst" ""
    sed '/noinst/d' -i configure.ac
    sed '/libcrafter/d' -i src/tracebox/Makefile.am
  '';

  meta = with stdenv.lib; {
    homepage = http://www.tracebox.org/;
    description = "A middlebox detection tool";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.lethalman ];
    platforms = platforms.linux;
  };
}
