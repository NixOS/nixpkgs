{ lib, stdenv, fetchFromGitHub } :
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
  postInstall = ''
    cp src/proxychains.conf $out/etc
  '';

  meta = {
    description = "Proxifier for SOCKS proxies";
    homepage = "http://proxychains.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
