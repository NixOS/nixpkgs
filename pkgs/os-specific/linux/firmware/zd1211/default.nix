{ stdenv
, lib
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "zd1211-firmware";
  version = "1.5";

  src = fetchurl {
    url = "mirror://sourceforge/zd1211/${pname}-${version}.tar.bz2";
    hash = "sha256-8R04ENf3KDOZf2NFhKWG3M7XGjU/llq/gQYuxDHQKxI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/zd1211
    cp * $out/lib/firmware/zd1211

    runHook postInstall
  '';

  meta = {
    description = "Firmware for the ZyDAS ZD1211(b) 802.11a/b/g USB WLAN chip";
    homepage = "https://sourceforge.net/projects/zd1211/";
    license = "GPL";
    platforms = lib.platforms.linux;
  };
}
