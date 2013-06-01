{ stdenv, fetchurl, iproute, lzo, openssl, pam }:

stdenv.mkDerivation rec {
  name = "openvpn-2.3.1";

  src = fetchurl {
    url = "http://swupdate.openvpn.net/community/releases/${name}.tar.gz";
    sha256 = "0g7vf3f6z0h4kdqlqr8jd0gapi0ains6xcvlvfy8cicxnf2psbdx";
  };

  buildInputs = [ iproute lzo openssl pam ];

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

  meta = {
    description = "A robust and highly flexible tunneling application";
    homepage = http://openvpn.net/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
