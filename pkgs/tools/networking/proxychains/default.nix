{ stdenv, fetchFromGitHub } :
stdenv.mkDerivation rec {
  name = "proxychains-${version}";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "haad";
    repo = "proxychains";
    rev = name;
    sha256 = "015skh3z1jmm8kxbm3nkqv1w56kcvabdmcbmpwzywxr4xnh3x3pc";
  };

  meta = {
    description = "Proxifier for SOCKS proxies";
    homepage = http://proxychains.sourceforge.net;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
