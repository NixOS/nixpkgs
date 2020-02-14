{
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "yamdi";
  version = "1.9";

  # Source repo is also available here:
  # https://github.com/ioppermann/yamdi
  src = fetchurl {
    url = "mirror://sourceforge/yamdi/yamdi-${version}.tar.gz";
    sha256 = "4a6630f27f6c22bcd95982bf3357747d19f40bd98297a569e9c77468b756f715";
  };

  buildFlags = [ "CC=cc" ];

  installPhase = ''
    install -D {,$out/bin/}yamdi
    install -D {,$out/share/man/}man1/yamdi.1
  '';

  meta = with stdenv.lib; {
    description = "Yet Another MetaData Injector for FLV";
    homepage = http://yamdi.sourceforge.net/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.ryanartecona ];
  };
}
