{ stdenv, fetchurl, iproute, lzo, openssl, pam, systemd }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "openvpn-2.3.3";

  src = fetchurl {
    url = "http://swupdate.openvpn.net/community/releases/${name}.tar.gz";
    sha256 = "04xiwim56sb1vis93k9hhm1s29jdrlq7i2fa07jncnhh653d29gh";
  };

  patches = optional stdenv.isLinux ./systemd-notify.patch;

  buildInputs = [ iproute lzo openssl pam ] ++ optional stdenv.isLinux systemd;

  configureFlags = ''
    --enable-password-save
    --enable-iproute2
    --enable-systemd
    IPROUTE=${iproute}/sbin/ip
  '';

  preConfigure = ''
    substituteInPlace ./src/openvpn/console.c \
      --replace /bin/systemd-ask-password /run/current-system/sw/bin/systemd-ask-password
  '';

  postInstall = ''
    mkdir -p $out/share/doc/openvpn/examples
    cp -r sample/sample-config-files/ $out/share/doc/openvpn/examples
    cp -r sample/sample-keys/ $out/share/doc/openvpn/examples
    cp -r sample/sample-scripts/ $out/share/doc/openvpn/examples
  '';

  enableParallelBuilding = true;

  NIX_LDFLAGS = optionalString stdenv.isLinux "-lsystemd-daemon"; # hacky

  meta = {
    description = "A robust and highly flexible tunneling application";
    homepage = http://openvpn.net/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
