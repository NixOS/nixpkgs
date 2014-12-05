{ stdenv, fetchurl, iproute, lzo, openssl, pam, systemd, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "openvpn-2.3.6";

  src = fetchurl {
    url = "http://swupdate.openvpn.net/community/releases/${name}.tar.gz";
    sha256 = "09jvxr4wcsmk55gqv3cblm60kzs9ripv9h4y50d1lbn177zx5bkv";
  };

  patches = optional stdenv.isLinux ./systemd-notify.patch;

  buildInputs = [ iproute lzo openssl pam pkgconfig ] ++ optional stdenv.isLinux systemd;

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
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
