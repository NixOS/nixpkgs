{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ascii-${version}";
  version = "3.12";

  src = fetchurl {
    url = "http://www.catb.org/~esr/ascii/${name}.tar.gz";
    sha256 = "17jhmmdbhzzaai0lr5aslg0nmqchq1ygdxwd8pgl7qn2jnxhc6ci";
  };

  prePatch = ''
    sed -i -e 's|$(DESTDIR)/usr|$(out)|g' Makefile
  '';

  preInstall = ''
    mkdir -vp "$out/bin" "$out/share/man/man1"
  '';

  meta = with stdenv.lib; {
    description = "Interactive ASCII name and synonym chart";
    homepage = "http://www.catb.org/~esr/ascii/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
