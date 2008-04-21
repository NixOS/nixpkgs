{stdenv, fetchurl, openssl}:

stdenv.mkDerivation {
  name = "wpa_supplicant-0.6.3";

  src = fetchurl {
    url = http://hostap.epitest.fi/releases/wpa_supplicant-0.6.3.tar.gz;
    sha256 = "f70b18243e049bbda66254388b6e94d404e747d913b8496d6e93a9c56bbf4af2";
  };

  preBuild = "
    cd wpa_supplicant
    cp defconfig .config
    substituteInPlace Makefile --replace /usr/local $out
    makeFlagsArray=(ALL=\"wpa_supplicant wpa_passphrase wpa_cli\")
  ";

  buildInputs = [openssl];
}
