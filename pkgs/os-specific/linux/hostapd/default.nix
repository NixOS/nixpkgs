{ stdenv, fetchurl, libnl1, openssl }:
stdenv.mkDerivation rec {

  name = "hostapd-${version}";
  version = "0.7.3";

  src = fetchurl {
    url = http://w1.fi/releases/hostapd-0.7.3.tar.gz;
    sha256 = "0rqmjs4k50qjp2d0k71lg5vsh34w07w985cxjqklq6kyyf0jgsri";
  };

  buildInputs = [ libnl1 openssl ];

  configurePhase = ''
    cd hostapd
    substituteInPlace defconfig --replace "#CONFIG_DRIVER_NL80211" "CONFIG_DRIVER_NL80211"
    substituteInPlace Makefile --replace "/usr/local/bin/" "$out/bin/"
    mv defconfig .config
  '';
  preInstall = "mkdir -p $out/bin";

  meta = with stdenv.lib; {
    homepage = http://w1.fi/hostapd/;
    description = "A user space daemon for access point and authentication servers";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}