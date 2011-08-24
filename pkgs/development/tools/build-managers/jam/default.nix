{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jam-2.5";
  src = fetchurl {
    url = ftp://ftp.perforce.com/jam/jam-2.5.tar;
    sha256 = "04c6khd7gdkqkvx4h3nbz99lyz7waid4fd221hq5chcygyx1sj3i";
  };

  installPhase = ''
    ensureDir $out/bin
    cp bin.linux/jam $out/bin
  '';

  meta = {
    homepage = http://public.perforce.com/wiki/Jam;
    license = "free";
    description = "Just Another Make";
  };
}
