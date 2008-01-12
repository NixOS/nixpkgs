{stdenv, fetchurl, openssl}:

stdenv.mkDerivation {
  name = "wpa_supplicant-0.5.9";

  src = fetchurl {
    url = http://hostap.epitest.fi/releases/wpa_supplicant-0.5.9.tar.gz;
    sha256 = "1dylaiikp2jb13jbxdrl1h9b9p2lkjmzx06hpmkcpyq5c5g7p0xy";
  };

  preBuild = "
    cp defconfig .config
    substituteInPlace Makefile --replace /usr/local $out
    makeFlagsArray=(ALL=\"wpa_supplicant wpa_passphrase wpa_cli\")
  ";

  buildInputs = [openssl];
}
