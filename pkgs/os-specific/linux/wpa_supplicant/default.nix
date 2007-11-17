{stdenv, fetchurl, openssl}:

stdenv.mkDerivation {
  name = "wpa_supplicant-0.5.8";

  src = fetchurl {
    url = http://hostap.epitest.fi/releases/wpa_supplicant-0.5.8.tar.gz;
    sha256 = "1w37bm42gh1k0v3r8cdmyrvf5rk5fyz9bvsp10w2cvgrwgi5b5rg";
  };

  preBuild = "
    cp defconfig .config
    substituteInPlace Makefile --replace /usr/local $out
    makeFlagsArray=(ALL=\"wpa_supplicant wpa_passphrase wpa_cli\")
  ";

  buildInputs = [openssl];
}
