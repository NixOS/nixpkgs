{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "swarm-${version}";
  version = "3.1";

  src = fetchurl {
    url = "http://www.spinroot.com/swarm/swarm${version}.tar";
    sha256 = "12hi6wy0v0jfbrmgfxpnz7vxfzz3g1c6z7dj8p8kc2nm0q5bii47";
  };

  sourceRoot = ".";

  buildPhase = ''
    gcc -O2 -lm swarm.c -o swarm
  '';

  installPhase = ''
    install -Dm755 swarm $out/bin/swarm
    install -Dm644 swarm.1 $out/share/man/man1/swarm.1
  '';

  meta = with stdenv.lib; {
    description = "Verification script generator for Spin";
    homepage = http://spinroot.com/;
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
