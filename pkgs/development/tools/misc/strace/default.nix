{ stdenv, fetchurl, perl, libunwind }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "4.21";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${name}.tar.xz";
    sha256 = "0dsw6xcfrmygidp1dj2ch8cl8icrar7789snkb2r8gh78kdqhxjw";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ libunwind ]; # support -k

  configureFlags = stdenv.lib.optional stdenv.hostPlatform.isAarch64 "--enable-mpers=check";

  meta = with stdenv.lib; {
    homepage = http://strace.io/;
    description = "A system call tracer for Linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds globin ];
  };
}
