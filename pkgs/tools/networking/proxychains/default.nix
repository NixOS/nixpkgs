{ stdenv, fetchFromGitHub } :
stdenv.mkDerivation rec {
  pname = "proxychains";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "haad";
    repo = "proxychains";
    rev = "${pname}-${version}";
    sha256 = "015skh3z1jmm8kxbm3nkqv1w56kcvabdmcbmpwzywxr4xnh3x3pc";
  };

  postPatch = ''
    # Temporary work-around; most likely fixed by next upstream release
    sed -i Makefile -e '/-lpthread/a LDFLAGS+=-ldl'
  '';

  meta = {
    description = "Proxifier for SOCKS proxies";
    homepage = "http://proxychains.sourceforge.net";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
