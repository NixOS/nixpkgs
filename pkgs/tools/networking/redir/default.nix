{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "redir-2.2.1";

  src = fetchurl {
    url = "http://sammy.net/~sammy/hacks/${name}.tar.gz";
    sha256 = "0v0f14br00rrmd1ss644adsby4gm29sn7a2ccy7l93ik6pw099by";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp redir $out/bin
  '';

  meta = {
    description = "A port redirector";
    homepage = http://sammy.net/~sammy/hacks/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ globin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
