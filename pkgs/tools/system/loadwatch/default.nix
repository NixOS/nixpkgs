{ stdenv, fetchurl, ... }:

stdenv.mkDerivation {
  name = "loadwatch-1.1";
  src = fetchurl {
    url = "mirror://debian/pool/main/l/loadwatch/loadwatch_1.0+1.1alpha1.orig.tar.gz";
    sha256 = "1abjl3cy4sa4ivdm7wghv9rq93h8kix4wjbiv7pb906rdqs4881a";
  };
  installPhase = ''
    mkdir -p $out/bin
    install loadwatch lw-ctl $out/bin
  '';
  meta = with stdenv.lib; {
    description = "Run a program using only idle cycles";
    license = licenses.gpl2;
    maintainers = with maintainers; [ woffs ];
    platforms = platforms.linux;
  };
}
