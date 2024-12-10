{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "915resolution";
  version = "0.5.3";

  src = fetchurl {
    url = "http://915resolution.mango-lang.org/915resolution-${version}.tar.gz";
    sha256 = "0hmmy4kkz3x6yigz6hk99416ybznd67dpjaxap50nhay9f1snk5n";
  };

  patchPhase = "rm *.o";
  installPhase = "mkdir -p $out/sbin; cp 915resolution $out/sbin/";

  meta = with lib; {
    homepage = "http://915resolution.mango-lang.org/";
    description = "A tool to modify Intel 800/900 video BIOS";
    mainProgram = "915resolution";
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    license = licenses.publicDomain;
  };
}
