{ fetchzip }:

rec {
  version = "3.4.5";
  src = fetchzip {
    url = "https://github.com/NICMx/releases/raw/master/Jool/Jool-${version}.zip";
    sha256 = "045j3ax6c5jg8037hhrbgqgznr0a114xrmn03wkasnvsxpsx4hkb";
  };
}
