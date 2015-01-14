{ stdenv, fetchurl, pkgconfig, libdaemon, bison, flex, check }:

stdenv.mkDerivation rec {
  name = "radvd-2.9";
  
  src = fetchurl {
    url = "http://www.litech.org/radvd/dist/${name}.tar.xz";
    sha256 = "1f5sbfh1va02nlrp5jx8zshyjqpz07ga15jx9kqphqzwlwxsspjj";
  };

  buildInputs = [ pkgconfig libdaemon bison flex check ];

  meta = with stdenv.lib; {
    homepage = http://www.litech.org/radvd/;
    description = "IPv6 Router Advertisement Daemon";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ wkennington ];
  };
}
