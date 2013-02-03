{ stdenv, fetchurl, libnl, openssl, pkgconfig }:
stdenv.mkDerivation rec {

  name = "hostapd-${version}";
  version = "1.0";

  src = fetchurl {
    url = "http://w1.fi/releases/${name}.tar.gz";
    sha256 = "1k6z2g0g324593a7ybd76bywvj0gnf9cybqaj2sq5ks6gv5rsbh0";
  };

  buildInputs = [ libnl openssl pkgconfig ];

  configurePhase = ''
    cd hostapd
    substituteInPlace Makefile --replace "/usr/local/bin" "$out/bin"
    mv defconfig .config
    echo CONFIG_LIBNL32=y | tee -a .config
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libnl-3.0)"
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