{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "zd1211-firmware";
  version = "1.4";

  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "http://surfnet.dl.sourceforge.net/sourceforge/zd1211/${name}.tar.bz2";
    sha256 = "866308f6f59f7075f075d4959dff2ede47735c751251fecd1496df1ba4d338e1";
  };
  
  buildPhase = "true";

  installPhase = "ensureDir $out/zd1211; cp * $out/zd1211";
  
  meta = {
    description = "Firmware for the ZyDAS ZD1211(b) 802.11a/b/g USB WLAN chip";
    homepage = http://sourceforge.net/projects/zd1211/;
    license = "GPL";
  };
}
