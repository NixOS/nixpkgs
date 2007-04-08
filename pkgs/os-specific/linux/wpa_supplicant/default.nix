{stdenv, fetchurl, openssl}:

stdenv.mkDerivation {
  name = "wpa_supplicant-0.5.7";

  src = fetchurl {
    url = http://hostap.epitest.fi/releases/wpa_supplicant-0.5.7.tar.gz;
    sha256 = "0mvb2fpvn7qdjinpn86hvmhfwg2ax1822hdkfrw25wx5dglqns6g";
  };

  preBuild = "
    cp defconfig .config
    substituteInPlace Makefile --replace /usr/local $out
    makeFlagsArray=(ALL=\"wpa_supplicant wpa_passphrase wpa_cli\")
  ";

  buildInputs = [openssl];
}
