{ stdenv, fetchurl, iproute, lzo, openssl, pam, systemd, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "openvpn-2.3.8";

  src = fetchurl {
    url = "http://swupdate.openvpn.net/community/releases/${name}.tar.gz";
    sha256 = "0lbw22qv3m0axhs13razr6b4x1p7jcpvf9rzb15b850wyvpka92k";
  };

  patches = optional stdenv.isLinux ./systemd-notify.patch;

  buildInputs = [ lzo openssl pkgconfig ]
                  ++ optionals stdenv.isLinux [ pam systemd iproute ];

  configureFlags = ''
    --enable-password-save
  '' + optionalString stdenv.isLinux ''
    --enable-systemd
    --enable-iproute2
    IPROUTE=${iproute}/sbin/ip
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
