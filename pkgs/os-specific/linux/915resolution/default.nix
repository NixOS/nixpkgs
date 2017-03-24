{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "915resolution-0.5.3";
  
  src = fetchurl {
    url = "http://915resolution.mango-lang.org/${name}.tar.gz";
    sha256 = "0hmmy4kkz3x6yigz6hk99416ybznd67dpjaxap50nhay9f1snk5n";
  };

  patchPhase = "rm *.o";
  installPhase = "mkdir -p $out/sbin; cp 915resolution $out/sbin/";

  meta = with stdenv.lib; {
    homepage = http://915resolution.mango-lang.org/;
    description = "A tool to modify Intel 800/900 video BIOS";
    platforms = platforms.linux;
  };
}
