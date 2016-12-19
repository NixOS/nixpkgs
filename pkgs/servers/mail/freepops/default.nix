{stdenv, fetchurl, pkgconfig, openssl, lua5, curl, readline, bison, expat}:

stdenv.mkDerivation {
  name = "freepops-0.2.9";
  src = fetchurl {
    url = mirror://sourceforge/freepops/0.2.9/freepops-0.2.9.tar.gz;
    sha256 = "3a065e30cafed03d9b6fdb28251ae5bf0d8aeb62181746154beecd25dc0c9cae";
  };
  buildInputs = [pkgconfig openssl lua5 curl readline bison expat];
  configurePhase =
  ''
    export WHERE=$prefix/
    export LOCALEDIR=$prefix/share/locale/
    ./configure.sh linux
  '';

  meta = {
    description = "An extensible pop3 server";
    longDescription = ''
      FreePOPs is an extensible pop3 server. Its main purpose is to provide
      a pop3 interface to a webmail.
    '';
    homepage = http://www.freepops.org/;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ pierron ];
    broken = true;
  };
}
