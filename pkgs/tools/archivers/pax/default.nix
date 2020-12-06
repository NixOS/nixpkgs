{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pax";
  version = "20201030";

  src = fetchurl {
    url = "http://www.mirbsd.org/MirOS/dist/mir/cpio/paxmirabilis-${version}.tgz";
    sha256 = "1p18nxijh323f4i1s2pg7pcr0557xljl5avv8ll5s9nfr34r5j0w";
  };

  buildPhase = ''
    sh Build.sh -r -tpax
  '';

  installPhase = ''
    install -Dm555 pax $out/bin/pax
    ln -s $out/bin/pax $out/bin/paxcpio
    ln -s $out/bin/pax $out/bin/paxtar
    install -Dm444 mans/pax{,cpio,tar}.1 -t $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "POSIX standard archive tool from MirBSD";
    homepage = "https://www.mirbsd.org/pax.htm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
